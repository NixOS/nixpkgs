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
    explicit Out(std::ostream & ostream) : ostream(ostream), policy(ONE_LINE), write_since_sep(true) {}
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
    bool write_since_sep;
    template <typename T> friend Out & operator<<(Out & o, T thing);
};

template <typename T> Out & operator<<(Out & o, T thing)
{
    if (!o.write_since_sep && o.policy == Out::MULTI_LINE) {
        o.ostream << o.indentation;
    }
    o.write_since_sep = true;
    o.ostream << thing;
    return o;
}

template <> Out & operator<<<Out::Separator>(Out & o, Out::Separator /* thing */)
{
    o.ostream << (o.policy == Out::ONE_LINE ? " " : "\n");
    o.write_since_sep = false;
    return o;
}

Out::Out(Out & o, const std::string & start, const std::string & end, LinePolicy policy)
    : ostream(o.ostream), indentation(policy == ONE_LINE ? o.indentation : o.indentation + "  "),
      end(policy == ONE_LINE ? end : o.indentation + end), policy(policy), write_since_sep(true)
{
    o << start;
    *this << Out::sep;
}

// Stuff needed for evaluation
struct Context
{
    Context(EvalState & state, Bindings & autoArgs, Value options_root, Value config_root)
        : state(state), autoArgs(autoArgs), options_root(options_root), config_root(config_root),
          underscore_type(state.symbols.create("_type"))
    {}
    EvalState & state;
    Bindings & autoArgs;
    Value options_root;
    Value config_root;
    Symbol underscore_type;
};

Value evaluateValue(Context * ctx, Value * v)
{
    ctx->state.forceValue(*v);
    if (ctx->autoArgs.empty()) {
        return *v;
    }
    Value called{};
    ctx->state.autoCallFunction(ctx->autoArgs, *v, called);
    return called;
}

bool isOption(Context * ctx, const Value & v)
{
    if (v.type != tAttrs) {
        return false;
    }
    const auto & actual_type = v.attrs->find(ctx->underscore_type);
    if (actual_type == v.attrs->end()) {
        return false;
    }
    try {
        Value evaluated_type = evaluateValue(ctx, actual_type->value);
        if (evaluated_type.type != tString) {
            return false;
        }
        return static_cast<std::string>(evaluated_type.string.s) == "option";
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
             Context * ctx, Value v, const std::string & path)
{
    std::variant<Value, std::exception_ptr> evaluated;
    try {
        evaluated = evaluateValue(ctx, &v);
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
void mapOptions(const std::function<void(const std::string & path)> & f, Context * ctx, Value root)
{
    recurse(
        [f, ctx](const std::string & path, std::variant<Value, std::exception_ptr> v) {
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
    const std::string & path, Context * ctx)
{
    Value * option;
    try {
        option = findAlongAttrPath(ctx->state, path, ctx->autoArgs, ctx->config_root);
    } catch (Error &) {
        f(path, std::current_exception());
        return;
    }
    recurse(
        [f, ctx](const std::string & path, std::variant<Value, std::exception_ptr> v) {
            bool leaf = std::holds_alternative<std::exception_ptr>(v) || std::get<Value>(v).type != tAttrs ||
                        ctx->state.isDerivation(std::get<Value>(v));
            if (!leaf) {
                return true; // Keep digging
            }
            f(path, v);
            return false;
        },
        ctx, *option, path);
}

std::string describeError(const Error & e) { return "«error: " + e.msg() + "»"; }

void describeDerivation(Context * ctx, Out & out, Value v)
{
    // Copy-pasted from nix/src/nix/repl.cc  :(
    Bindings::iterator i = v.attrs->find(ctx->state.sDrvPath);
    PathSet pathset;
    try {
        Path drvPath = i != v.attrs->end() ? ctx->state.coerceToPath(*i->pos, *i->value, pathset) : "???";
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

void printValue(Context * ctx, Out & out, std::variant<Value, std::exception_ptr> maybe_value,
                const std::string & path);

void printList(Context * ctx, Out & out, Value & v)
{
    Out list_out(out, "[", "]", v.listSize());
    for (unsigned int n = 0; n < v.listSize(); ++n) {
        printValue(ctx, list_out, *v.listElems()[n], "");
        list_out << Out::sep;
    }
}

void printAttrs(Context * ctx, Out & out, Value & v, const std::string & path)
{
    Out attrs_out(out, "{", "}", v.attrs->size());
    for (const auto & a : v.attrs->lexicographicOrder()) {
        std::string name = a->name;
        attrs_out << name << " = ";
        printValue(ctx, attrs_out, *a->value, appendPath(path, name));
        attrs_out << ";" << Out::sep;
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
    Out str_out(out, "''", "''", Out::MULTI_LINE);
    std::string::size_type begin = 0;
    while (begin < s.size()) {
        std::string::size_type end = s.find('\n', begin);
        if (end == std::string::npos) {
            multiLineStringEscape(str_out, s.substr(begin, s.size() - begin));
            break;
        }
        multiLineStringEscape(str_out, s.substr(begin, end - begin));
        str_out << Out::sep;
        begin = end + 1;
    }
}

void printValue(Context * ctx, Out & out, std::variant<Value, std::exception_ptr> maybe_value, const std::string & path)
{
    try {
        if (auto ex = std::get_if<std::exception_ptr>(&maybe_value)) {
            std::rethrow_exception(*ex);
        }
        Value v = evaluateValue(ctx, &std::get<Value>(maybe_value));
        if (ctx->state.isDerivation(v)) {
            describeDerivation(ctx, out, v);
        } else if (v.isList()) {
            printList(ctx, out, v);
        } else if (v.type == tAttrs) {
            printAttrs(ctx, out, v, path);
        } else if (v.type == tString && std::string(v.string.s).find('\n') != std::string::npos) {
            printMultiLineString(out, v);
        } else {
            ctx->state.forceValueDeep(v);
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

void printConfigValue(Context * ctx, Out & out, const std::string & path, std::variant<Value, std::exception_ptr> v)
{
    out << path << " = ";
    printValue(ctx, out, std::move(v), path);
    out << ";\n";
}

void printAll(Context * ctx, Out & out)
{
    mapOptions(
        [ctx, &out](const std::string & option_path) {
            mapConfigValuesInOption(
                [ctx, &out](const std::string & config_path, std::variant<Value, std::exception_ptr> v) {
                    printConfigValue(ctx, out, config_path, v);
                },
                option_path, ctx);
        },
        ctx, ctx->options_root);
}

void printAttr(Context * ctx, Out & out, const std::string & path, Value * root)
{
    try {
        printValue(ctx, out, *findAlongAttrPath(ctx->state, path, ctx->autoArgs, *root), path);
    } catch (Error & e) {
        out << describeError(e);
    }
}

void printOption(Context * ctx, Out & out, const std::string & path, Value * option)
{
    out << "Value:\n";
    printAttr(ctx, out, path, &ctx->config_root);

    out << "\n\nDefault:\n";
    printAttr(ctx, out, "default", option);

    out << "\n\nType:\n";
    printAttr(ctx, out, "type.description", option);

    out << "\n\nExample:\n";
    printAttr(ctx, out, "example", option);

    out << "\n\nDescription:\n";
    printAttr(ctx, out, "description", option);

    out << "\n\nDeclared by:\n";
    printAttr(ctx, out, "declarations", option);

    out << "\n\nDefined by:\n";
    printAttr(ctx, out, "files", option);
    out << "\n";
}

void printListing(Out & out, Value * v)
{
    // Print this header on stderr rather than stdout because the old shell script
    // implementation did.  I don't know why.
    std::cerr << "This attribute set contains:\n";
    for (const auto & a : v->attrs->lexicographicOrder()) {
        std::string name = a->name;
        if (!name.empty() && name[0] != '_') {
            out << name << "\n";
        }
    }
}

bool optionTypeIs(Context * ctx, Value & v, const std::string & sought_type)
{
    try {
        const auto & type_lookup = v.attrs->find(ctx->state.sType);
        if (type_lookup == v.attrs->end()) {
            return false;
        }
        Value type = evaluateValue(ctx, type_lookup->value);
        if (type.type != tAttrs) {
            return false;
        }
        const auto & name_lookup = type.attrs->find(ctx->state.sName);
        if (name_lookup == type.attrs->end()) {
            return false;
        }
        Value name = evaluateValue(ctx, name_lookup->value);
        if (name.type != tString) {
            return false;
        }
        return name.string.s == sought_type;
    } catch (Error &) {
        return false;
    }
}

MakeError(OptionPathError, EvalError);

Value getSubOptions(Context * ctx, Value & option)
{
    Value getSubOptions =
        evaluateValue(ctx, findAlongAttrPath(ctx->state, "type.getSubOptions", ctx->autoArgs, option));
    if (getSubOptions.type != tLambda) {
        throw OptionPathError("Option's type.getSubOptions isn't a function");
    }
    Value emptyString{};
    nix::mkString(emptyString, "");
    Value v;
    ctx->state.callFunction(getSubOptions, emptyString, v, nix::Pos{});
    return v;
}

// Carefully walk an option path, looking for sub-options when a path walks past
// an option value.
Value findAlongOptionPath(Context * ctx, const std::string & path)
{
    Strings tokens = parseAttrPath(path);
    Value v = ctx->options_root;
    for (auto i = tokens.begin(); i != tokens.end(); i++) {
        const auto & attr = *i;
        try {
            bool last_attribute = std::next(i) == tokens.end();
            v = evaluateValue(ctx, &v);
            if (attr.empty()) {
                throw OptionPathError("empty attribute name");
            }
            if (isOption(ctx, v) && optionTypeIs(ctx, v, "submodule")) {
                v = getSubOptions(ctx, v);
            }
            if (isOption(ctx, v) && optionTypeIs(ctx, v, "loaOf") && !last_attribute) {
                v = getSubOptions(ctx, v);
                // Note that we've consumed attr, but didn't actually use it.  This is the path component that's looked
                // up in the list or attribute set that doesn't name an option -- the "root" in "users.users.root.name".
            } else if (v.type != tAttrs) {
                throw OptionPathError("Value is %s while a set was expected", showType(v));
            } else {
                const auto & next = v.attrs->find(ctx->state.symbols.create(attr));
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

void printOne(Context * ctx, Out & out, const std::string & path)
{
    try {
        Value option = findAlongOptionPath(ctx, path);
        option = evaluateValue(ctx, &option);
        if (isOption(ctx, option)) {
            printOption(ctx, out, path, &option);
        } else {
            printListing(out, &option);
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
    std::string options_expr = "(import <nixpkgs/nixos> {}).options";
    std::string config_expr = "(import <nixpkgs/nixos> {}).config";
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
            options_expr = nix::getArg(*arg, arg, end);
        } else if (*arg == "--config_expr") {
            config_expr = nix::getArg(*arg, arg, end);
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

    Value options_root = parseAndEval(*state, options_expr, path);
    Value config_root = parseAndEval(*state, config_expr, path);

    Context ctx{*state, *myArgs.getAutoArgs(*state), options_root, config_root};
    Out out(std::cout);

    if (all) {
        if (!args.empty()) {
            throw UsageError("--all cannot be used with arguments");
        }
        printAll(&ctx, out);
    } else {
        if (args.empty()) {
            printOne(&ctx, out, "");
        }
        for (const auto & arg : args) {
            printOne(&ctx, out, arg);
        }
    }

    ctx.state.printStats();

    return 0;
}
