#include <nix/config.h> // for nix/globals.hh's reference to SYSTEM

#include <exception>               // for exception_ptr, current_exception
#include <functional>              // for function
#include <iostream>                // for operator<<, basic_ostream, ostrin...
#include <iterator>                // for next
#include <list>                    // for _List_iterator
#include <memory>                  // for allocator, unique_ptr, make_unique
#include <new>                     // for operator new
#include <nix/args.hh>             // for argvToStrings, UsageError
#include <nix/attr-path.hh>        // for findAlongAttrPath
#include <nix/attr-set.hh>         // for Attr, Bindings, Bindings::iterator
#include <nix/common-eval-args.hh> // for MixEvalArgs
#include <nix/eval-inline.hh>      // for EvalState::forceValue
#include <nix/eval.hh>             // for EvalState, initGC, operator<<
#include <nix/globals.hh>          // for initPlugins, Settings, settings
#include <nix/nixexpr.hh>          // for Pos
#include <nix/shared.hh>           // for getArg, LegacyArgs, printVersion
#include <nix/store-api.hh>        // for openStore
#include <nix/symbol-table.hh>     // for Symbol, SymbolTable
#include <nix/types.hh>            // for Error, Path, Strings, PathSet
#include <nix/util.hh>             // for absPath, baseNameOf
#include <nix/value.hh>            // for Value, Value::(anonymous), Value:...
#include <string>                  // for string, operator+, operator==
#include <utility>                 // for move
#include <variant>                 // for get, holds_alternative, variant
#include <vector>                  // for vector<>::iterator, vector

#include "libnix-copy-paste.hh"

using nix::absPath;
using nix::Bindings;
using nix::Error;
using nix::EvalError;
using nix::EvalState;
using nix::Path;
using nix::PathSet;
using nix::Strings;
using nix::Symbol;
using nix::tAttrs;
using nix::ThrownError;
using nix::tLambda;
using nix::tString;
using nix::UsageError;
using nix::Value;

// An ostream wrapper to handle nested indentation
class Out
{
  public:
    class Separator
    {};
    const static Separator sep;
    enum LinePolicy
    {
        ONE_LINE,
        MULTI_LINE
    };
    explicit Out(std::ostream & ostream) : ostream(ostream), policy(ONE_LINE), writeSinceSep(true) {}
    Out(Out & o, const std::string & start, const std::string & end, LinePolicy policy);
    Out(Out & o, const std::string & start, const std::string & end, int count)
        : Out(o, start, end, count < 2 ? ONE_LINE : MULTI_LINE)
    {}
    Out(const Out &) = delete;
    Out(Out &&) = default;
    Out & operator=(const Out &) = delete;
    Out & operator=(Out &&) = delete;
    ~Out() { ostream << end; }

  private:
    std::ostream & ostream;
    std::string indentation;
    std::string end;
    LinePolicy policy;
    bool writeSinceSep;
    template <typename T> friend Out & operator<<(Out & o, T thing);
};

template <typename T> Out & operator<<(Out & o, T thing)
{
    if (!o.writeSinceSep && o.policy == Out::MULTI_LINE) {
        o.ostream << o.indentation;
    }
    o.writeSinceSep = true;
    o.ostream << thing;
    return o;
}

template <> Out & operator<<<Out::Separator>(Out & o, Out::Separator /* thing */)
{
    o.ostream << (o.policy == Out::ONE_LINE ? " " : "\n");
    o.writeSinceSep = false;
    return o;
}

Out::Out(Out & o, const std::string & start, const std::string & end, LinePolicy policy)
    : ostream(o.ostream), indentation(policy == ONE_LINE ? o.indentation : o.indentation + "  "),
      end(policy == ONE_LINE ? end : o.indentation + end), policy(policy), writeSinceSep(true)
{
    o << start;
    *this << Out::sep;
}

// Stuff needed for evaluation
struct Context
{
    Context(EvalState & state, Bindings & autoArgs, Value optionsRoot, Value configRoot)
        : state(state), autoArgs(autoArgs), optionsRoot(optionsRoot), configRoot(configRoot),
          underscoreType(state.symbols.create("_type"))
    {}
    EvalState & state;
    Bindings & autoArgs;
    Value optionsRoot;
    Value configRoot;
    Symbol underscoreType;
};

Value evaluateValue(Context & ctx, Value & v)
{
    ctx.state.forceValue(v);
    if (ctx.autoArgs.empty()) {
        return v;
    }
    Value called{};
    ctx.state.autoCallFunction(ctx.autoArgs, v, called);
    return called;
}

bool isOption(Context & ctx, const Value & v)
{
    if (v.type != tAttrs) {
        return false;
    }
    const auto & atualType = v.attrs->find(ctx.underscoreType);
    if (atualType == v.attrs->end()) {
        return false;
    }
    try {
        Value evaluatedType = evaluateValue(ctx, *atualType->value);
        if (evaluatedType.type != tString) {
            return false;
        }
        return static_cast<std::string>(evaluatedType.string.s) == "option";
    } catch (Error &) {
        return false;
    }
}

// Add quotes to a component of a path.
// These are needed for paths like:
//    fileSystems."/".fsType
//    systemd.units."dbus.service".text
std::string quoteAttribute(const std::string & attribute)
{
    if (isVarName(attribute)) {
        return attribute;
    }
    std::ostringstream buf;
    printStringValue(buf, attribute.c_str());
    return buf.str();
}

const std::string appendPath(const std::string & prefix, const std::string & suffix)
{
    if (prefix.empty()) {
        return quoteAttribute(suffix);
    }
    return prefix + "." + quoteAttribute(suffix);
}

bool forbiddenRecursionName(std::string name) { return (!name.empty() && name[0] == '_') || name == "haskellPackages"; }

void recurse(const std::function<bool(const std::string & path, std::variant<Value, std::exception_ptr>)> & f,
             Context & ctx, Value v, const std::string & path)
{
    std::variant<Value, std::exception_ptr> evaluated;
    try {
        evaluated = evaluateValue(ctx, v);
    } catch (Error &) {
        evaluated = std::current_exception();
    }
    if (!f(path, evaluated)) {
        return;
    }
    if (std::holds_alternative<std::exception_ptr>(evaluated)) {
        return;
    }
    const Value & evaluated_value = std::get<Value>(evaluated);
    if (evaluated_value.type != tAttrs) {
        return;
    }
    for (const auto & child : evaluated_value.attrs->lexicographicOrder()) {
        if (forbiddenRecursionName(child->name)) {
            continue;
        }
        recurse(f, ctx, *child->value, appendPath(path, child->name));
    }
}

// Calls f on all the option names
void mapOptions(const std::function<void(const std::string & path)> & f, Context & ctx, Value root)
{
    recurse(
        [f, &ctx](const std::string & path, std::variant<Value, std::exception_ptr> v) {
            bool isOpt = std::holds_alternative<std::exception_ptr>(v) || isOption(ctx, std::get<Value>(v));
            if (isOpt) {
                f(path);
            }
            return !isOpt;
        },
        ctx, root, "");
}

// Calls f on all the config values inside one option.
// Simple options have one config value inside, like sound.enable = true.
// Compound options have multiple config values.  For example, the option
// "users.users" has about 1000 config values inside it:
//   users.users.avahi.createHome = false;
//   users.users.avahi.cryptHomeLuks = null;
//   users.users.avahi.description = "`avahi-daemon' privilege separation user";
//   ...
//   users.users.avahi.openssh.authorizedKeys.keyFiles = [ ];
//   users.users.avahi.openssh.authorizedKeys.keys = [ ];
//   ...
//   users.users.avahi.uid = 10;
//   users.users.avahi.useDefaultShell = false;
//   users.users.cups.createHome = false;
//   ...
//   users.users.cups.useDefaultShell = false;
//   users.users.gdm = ... ... ...
//   users.users.messagebus = ... .. ...
//   users.users.nixbld1 = ... .. ...
//   ...
//   users.users.systemd-timesync = ... .. ...
void mapConfigValuesInOption(
    const std::function<void(const std::string & path, std::variant<Value, std::exception_ptr> v)> & f,
    const std::string & path, Context & ctx)
{
    Value * option;
    try {
        option = findAlongAttrPath(ctx.state, path, ctx.autoArgs, ctx.configRoot);
    } catch (Error &) {
        f(path, std::current_exception());
        return;
    }
    recurse(
        [f, ctx](const std::string & path, std::variant<Value, std::exception_ptr> v) {
            bool leaf = std::holds_alternative<std::exception_ptr>(v) || std::get<Value>(v).type != tAttrs ||
                        ctx.state.isDerivation(std::get<Value>(v));
            if (!leaf) {
                return true; // Keep digging
            }
            f(path, v);
            return false;
        },
        ctx, *option, path);
}

std::string describeError(const Error & e) { return "«error: " + e.msg() + "»"; }

void describeDerivation(Context & ctx, Out & out, Value v)
{
    // Copy-pasted from nix/src/nix/repl.cc  :(
    Bindings::iterator i = v.attrs->find(ctx.state.sDrvPath);
    PathSet pathset;
    try {
        Path drvPath = i != v.attrs->end() ? ctx.state.coerceToPath(*i->pos, *i->value, pathset) : "???";
        out << "«derivation " << drvPath << "»";
    } catch (Error & e) {
        out << describeError(e);
    }
}

Value parseAndEval(EvalState & state, const std::string & expression, const std::string & path)
{
    Value v{};
    state.eval(state.parseExprFromString(expression, absPath(path)), v);
    return v;
}

void printValue(Context & ctx, Out & out, std::variant<Value, std::exception_ptr> maybeValue, const std::string & path);

void printList(Context & ctx, Out & out, Value & v)
{
    Out listOut(out, "[", "]", v.listSize());
    for (unsigned int n = 0; n < v.listSize(); ++n) {
        printValue(ctx, listOut, *v.listElems()[n], "");
        listOut << Out::sep;
    }
}

void printAttrs(Context & ctx, Out & out, Value & v, const std::string & path)
{
    Out attrsOut(out, "{", "}", v.attrs->size());
    for (const auto & a : v.attrs->lexicographicOrder()) {
        std::string name = a->name;
        attrsOut << name << " = ";
        printValue(ctx, attrsOut, *a->value, appendPath(path, name));
        attrsOut << ";" << Out::sep;
    }
}

void multiLineStringEscape(Out & out, const std::string & s)
{
    int i;
    for (i = 1; i < s.size(); i++) {
        if (s[i - 1] == '$' && s[i] == '{') {
            out << "''${";
            i++;
        } else if (s[i - 1] == '\'' && s[i] == '\'') {
            out << "'''";
            i++;
        } else {
            out << s[i - 1];
        }
    }
    if (i == s.size()) {
        out << s[i - 1];
    }
}

void printMultiLineString(Out & out, const Value & v)
{
    std::string s = v.string.s;
    Out strOut(out, "''", "''", Out::MULTI_LINE);
    std::string::size_type begin = 0;
    while (begin < s.size()) {
        std::string::size_type end = s.find('\n', begin);
        if (end == std::string::npos) {
            multiLineStringEscape(strOut, s.substr(begin, s.size() - begin));
            break;
        }
        multiLineStringEscape(strOut, s.substr(begin, end - begin));
        strOut << Out::sep;
        begin = end + 1;
    }
}

void printValue(Context & ctx, Out & out, std::variant<Value, std::exception_ptr> maybeValue, const std::string & path)
{
    try {
        if (auto ex = std::get_if<std::exception_ptr>(&maybeValue)) {
            std::rethrow_exception(*ex);
        }
        Value v = evaluateValue(ctx, std::get<Value>(maybeValue));
        if (ctx.state.isDerivation(v)) {
            describeDerivation(ctx, out, v);
        } else if (v.isList()) {
            printList(ctx, out, v);
        } else if (v.type == tAttrs) {
            printAttrs(ctx, out, v, path);
        } else if (v.type == tString && std::string(v.string.s).find('\n') != std::string::npos) {
            printMultiLineString(out, v);
        } else {
            ctx.state.forceValueDeep(v);
            out << v;
        }
    } catch (ThrownError & e) {
        if (e.msg() == "The option `" + path + "' is used but not defined.") {
            // 93% of errors are this, and just letting this message through would be
            // misleading.  These values may or may not actually be "used" in the
            // config.  The thing throwing the error message assumes that if anything
            // ever looks at this value, it is a "use" of this value.  But here in
            // nixos-option, we are looking at this value only to print it.
            // In order to avoid implying that this undefined value is actually
            // referenced, eat the underlying error message and emit "«not defined»".
            out << "«not defined»";
        } else {
            out << describeError(e);
        }
    } catch (Error & e) {
        out << describeError(e);
    }
}

void printConfigValue(Context & ctx, Out & out, const std::string & path, std::variant<Value, std::exception_ptr> v)
{
    out << path << " = ";
    printValue(ctx, out, std::move(v), path);
    out << ";\n";
}

void printAll(Context & ctx, Out & out)
{
    mapOptions(
        [&ctx, &out](const std::string & optionPath) {
            mapConfigValuesInOption(
                [&ctx, &out](const std::string & configPath, std::variant<Value, std::exception_ptr> v) {
                    printConfigValue(ctx, out, configPath, v);
                },
                optionPath, ctx);
        },
        ctx, ctx.optionsRoot);
}

void printAttr(Context & ctx, Out & out, const std::string & path, Value & root)
{
    try {
        printValue(ctx, out, *findAlongAttrPath(ctx.state, path, ctx.autoArgs, root), path);
    } catch (Error & e) {
        out << describeError(e);
    }
}

bool hasExample(Context & ctx, Value & option)
{
    try {
        findAlongAttrPath(ctx.state, "example", ctx.autoArgs, option);
        return true;
    } catch (Error &) {
        return false;
    }
}

void printOption(Context & ctx, Out & out, const std::string & path, Value & option)
{
    out << "Value:\n";
    printAttr(ctx, out, path, ctx.configRoot);

    out << "\n\nDefault:\n";
    printAttr(ctx, out, "default", option);

    out << "\n\nType:\n";
    printAttr(ctx, out, "type.description", option);

    if (hasExample(ctx, option)) {
        out << "\n\nExample:\n";
        printAttr(ctx, out, "example", option);
    }

    out << "\n\nDescription:\n";
    printAttr(ctx, out, "description", option);

    out << "\n\nDeclared by:\n";
    printAttr(ctx, out, "declarations", option);

    out << "\n\nDefined by:\n";
    printAttr(ctx, out, "files", option);
    out << "\n";
}

void printListing(Out & out, Value & v)
{
    out << "This attribute set contains:\n";
    for (const auto & a : v.attrs->lexicographicOrder()) {
        std::string name = a->name;
        if (!name.empty() && name[0] != '_') {
            out << name << "\n";
        }
    }
}

bool optionTypeIs(Context & ctx, Value & v, const std::string & soughtType)
{
    try {
        const auto & typeLookup = v.attrs->find(ctx.state.sType);
        if (typeLookup == v.attrs->end()) {
            return false;
        }
        Value type = evaluateValue(ctx, *typeLookup->value);
        if (type.type != tAttrs) {
            return false;
        }
        const auto & nameLookup = type.attrs->find(ctx.state.sName);
        if (nameLookup == type.attrs->end()) {
            return false;
        }
        Value name = evaluateValue(ctx, *nameLookup->value);
        if (name.type != tString) {
            return false;
        }
        return name.string.s == soughtType;
    } catch (Error &) {
        return false;
    }
}

bool isAggregateOptionType(Context & ctx, Value & v)
{
    return optionTypeIs(ctx, v, "attrsOf") || optionTypeIs(ctx, v, "listOf") || optionTypeIs(ctx, v, "loaOf");
}

MakeError(OptionPathError, EvalError);

Value getSubOptions(Context & ctx, Value & option)
{
    Value getSubOptions = evaluateValue(ctx, *findAlongAttrPath(ctx.state, "type.getSubOptions", ctx.autoArgs, option));
    if (getSubOptions.type != tLambda) {
        throw OptionPathError("Option's type.getSubOptions isn't a function");
    }
    Value emptyString{};
    nix::mkString(emptyString, "");
    Value v;
    ctx.state.callFunction(getSubOptions, emptyString, v, nix::Pos{});
    return v;
}

// Carefully walk an option path, looking for sub-options when a path walks past
// an option value.
Value findAlongOptionPath(Context & ctx, const std::string & path)
{
    Strings tokens = parseAttrPath(path);
    Value v = ctx.optionsRoot;
    for (auto i = tokens.begin(); i != tokens.end(); i++) {
        const auto & attr = *i;
        try {
            bool lastAttribute = std::next(i) == tokens.end();
            v = evaluateValue(ctx, v);
            if (attr.empty()) {
                throw OptionPathError("empty attribute name");
            }
            if (isOption(ctx, v) && optionTypeIs(ctx, v, "submodule")) {
                v = getSubOptions(ctx, v);
            }
            if (isOption(ctx, v) && isAggregateOptionType(ctx, v) && !lastAttribute) {
                v = getSubOptions(ctx, v);
                // Note that we've consumed attr, but didn't actually use it.  This is the path component that's looked
                // up in the list or attribute set that doesn't name an option -- the "root" in "users.users.root.name".
            } else if (v.type != tAttrs) {
                throw OptionPathError("Value is %s while a set was expected", showType(v));
            } else {
                const auto & next = v.attrs->find(ctx.state.symbols.create(attr));
                if (next == v.attrs->end()) {
                    throw OptionPathError("Attribute not found", attr, path);
                }
                v = *next->value;
            }
        } catch (OptionPathError & e) {
            throw OptionPathError("At '%s' in path '%s': %s", attr, path, e.msg());
        }
    }
    return v;
}

void printOne(Context & ctx, Out & out, const std::string & path)
{
    try {
        Value option = findAlongOptionPath(ctx, path);
        option = evaluateValue(ctx, option);
        if (isOption(ctx, option)) {
            printOption(ctx, out, path, option);
        } else {
            printListing(out, option);
        }
    } catch (Error & e) {
        std::cerr << "error: " << e.msg()
                  << "\nAn error occurred while looking for attribute names. Are "
                     "you sure that '"
                  << path << "' exists?\n";
    }
}

int main(int argc, char ** argv)
{
    bool all = false;
    std::string path = ".";
    std::string optionsExpr = "(import <nixpkgs/nixos> {}).options";
    std::string configExpr = "(import <nixpkgs/nixos> {}).config";
    std::vector<std::string> args;

    struct MyArgs : nix::LegacyArgs, nix::MixEvalArgs
    {
        using nix::LegacyArgs::LegacyArgs;
    };

    MyArgs myArgs(nix::baseNameOf(argv[0]), [&](Strings::iterator & arg, const Strings::iterator & end) {
        if (*arg == "--help") {
            nix::showManPage("nixos-option");
        } else if (*arg == "--version") {
            nix::printVersion("nixos-option");
        } else if (*arg == "--all") {
            all = true;
        } else if (*arg == "--path") {
            path = nix::getArg(*arg, arg, end);
        } else if (*arg == "--options_expr") {
            optionsExpr = nix::getArg(*arg, arg, end);
        } else if (*arg == "--config_expr") {
            configExpr = nix::getArg(*arg, arg, end);
        } else if (!arg->empty() && arg->at(0) == '-') {
            return false;
        } else {
            args.push_back(*arg);
        }
        return true;
    });

    myArgs.parseCmdline(nix::argvToStrings(argc, argv));

    nix::initPlugins();
    nix::initGC();
    nix::settings.readOnlyMode = true;
    auto store = nix::openStore();
    auto state = std::make_unique<EvalState>(myArgs.searchPath, store);

    Value optionsRoot = parseAndEval(*state, optionsExpr, path);
    Value configRoot = parseAndEval(*state, configExpr, path);

    Context ctx{*state, *myArgs.getAutoArgs(*state), optionsRoot, configRoot};
    Out out(std::cout);

    if (all) {
        if (!args.empty()) {
            throw UsageError("--all cannot be used with arguments");
        }
        printAll(ctx, out);
    } else {
        if (args.empty()) {
            printOne(ctx, out, "");
        }
        for (const auto & arg : args) {
            printOne(ctx, out, arg);
        }
    }

    ctx.state.printStats();

    return 0;
}
