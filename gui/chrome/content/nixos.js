
function NixOS () {
  var env = Components.classes["@mozilla.org/process/environment;1"].
    getService(Components.interfaces.nsIEnvironment);

  if (env.exists("NIXOS"))
    this.nixos = env.get("NIXOS");
  if (env.exists("NIXOS_CONFIG"))
    this.config = env.get("NIXOS_CONFIG");
  if (env.exists("NIXPKGS"))
    this.nixpkgs = env.get("NIXPKGS");
  if (env.exists("mountPoint"))
    this.root = env.get("mountPoint");
  if (env.exists("NIXOS_OPTION"))
    this.optionBin = env.get("NIXOS_OPTION");
  this.option = new Option("options", this, null);
};

NixOS.prototype = {
  root: "",
  nixos: "/etc/nixos/nixos",
  nixpkgs: "/etc/nixos/nixpkgs",
  config: "/etc/nixos/configuration.nix",
  instantiateBin: "/var/run/current-system/sw/bin/nix-instantiate",
  optionBin: "/var/run/current-system/sw/bin/nixos-option",
  tmpFile: "nixos-gui",
  option: null
};

function Option (name, context, parent) {
  this.name = name;
  this.context_ = context;
  if (parent == null)
    this.path = "";
  else if (parent.path == "")
    this.path = name;
  else
    this.path = parent.path + "." + name;
};

Option.prototype = {
  load: function () {
    var env = "";
    env += "'NIXOS=" + this.context_.root + this.context_.nixos + "' ";
    env += "'NIXOS_PKGS=" + this.context_.root + this.context_.nixpkgs + "' ";
    env += "'NIXOS_CONFIG=" + this.context_.config + "' ";
    var out = makeTempFile(this.context_.tmpFile);
    var prog = this.context_.instantiateBin + " 2>&1 >" + out.path + " ";
    var args = "";
    args += " -A eval.options" + (this.path != "" ? "." : "") + this.path;
    args += " --eval-only --xml --no-location";
    args += " '" + this.context_.root + this.context_.nixos + "'";

    runProgram(/*env +*/ prog + args);
    var xml = readFromFile(out);
    out.remove(false);

    // jQuery does a stack overflow when converting a huge XML to a DOM.
    var dom = DOMParser().parseFromString(xml, "text/xml");
    var xmlAttrs = $("attr", dom);

    this.isOption = xmlAttrs
      .filter (
        function (idx) {
          return $(this).attr("name") == "_type";
          // !!! We could not rely on the value of the attribute because it
          // !!! may be unevaluated.
          // $(this).children("string[value='option']").length != 0;
        })
      .length != 0;

    if (!this.isOption)
    {
      var cur = this;
      var attrs = new Array();

      xmlAttrs.each(
        function (index) {
          var name = $(this).attr("name");
          var attr = new Option(name, cur.context_, cur);
          attrs.push(attr);
        }
      );

      this.subOptions = attrs;
    }
    else
    {
      this.loadDesc();
      // TODO: handle sub-options here.
    }
    this.isLoaded = true;
  },

  loadDesc:  function () {
    var env = "";
    env += "'NIXOS=" + this.context_.root + this.context_.nixos + "' ";
    env += "'NIXOS_PKGS=" + this.context_.root + this.context_.nixpkgs + "' ";
    env += "'NIXOS_CONFIG=" + this.context_.config + "' ";
    var out = makeTempFile(this.context_.tmpFile);
    var prog = this.context_.optionBin + " 2>&1 >" + out.path + " ";
    var args = " -vdl " + this.path;

    runProgram(/*env + */ prog + args);
    this.description = readFromFile(out);
    out.remove(false);
  },

  // keep the context under which this option has been used.
  context_: null,
  // name of the option.
  name: "",
  // result of nixos-option.
  description: "",
  // path to reach this option
  path: "",

  // list of options accessible from here.
  isLoaded: false,
  isOption: false,
  subOptions: []
};


/*
// Pretty print Nix values.
function nixPP(value, level)
{
  function indent(level) {  ret = ""; while (level--) ret+= "  "; return ret; }

  if (!level) level = 0;
  var ret = "<no match>";
  if (value.is("attrs")) {
    var content = "";
    value.children().each(function (){
      var name = $(this).attr("name");
      var value = nixPP($(this).children(), level + 1);
      content += indent(level + 1) + name + " = " + value + ";\n";
    });
    ret = "{\n" + content + indent(level) + "}";
  }
  else if (value.is("list")) {
    var content = "";
    value.children().each(function (){
      content += indent(level + 1) + "(" + nixPP($(this), level + 1) + ")\n";
    });
    ret = "[\n" + content + indent(level) + "]";
  }
  else if (value.is("bool"))
    ret = (value.attr("value") == "true");
  else if (value.is("string"))
    ret = '"' + value.attr("value") + '"';
  else if (value.is("path"))
    ret = value.attr("value");
  else if (value.is("int"))
    ret = parseInt(value.attr("value"));
  else if (value.is("derivation"))
    ret = value.attr("outPath");
  else if (value.is("function"))
    ret = "<function>";
  else {
    var content = "";
    value.children().each(function (){
      content += indent(level + 1) + "(" + nixPP($(this), level + 1) + ")\n";
    });
    ret = "<!--" + value.selector + "--><!--\n" + content + indent(level) + "-->";
  }
  return ret;
}

// Function used to reproduce the select operator on the XML DOM.
// It return the value contained in the targeted attribute.
function nixSelect(attrs, selector)
{
  var names = selector.split(".");
  var value = $(attrs);
  for (var i = 0; i < names.length; i++) {
    log(nixPP(value) + "." + names[i]);
    if (value.is("attrs"))
      value = value.children("attr[name='" + names[i] + "']").children();
    else {
      log("Cannot do an attribute selection.");
      break;
    }
  }

  log("nixSelect return: " + nixPP(value));

  var ret;
  if (value.is("attrs") || value.is("list"))
    ret = value;
  else if (value.is("bool"))
    ret = value.attr("value") == "true";
  else if (value.is("string"))
    ret = value.attr("value");
  else if (value.is("int"))
    ret = parseInt(value.attr("value"));
  else if (value.is("derivation"))
    ret = value.attr("outPath");
  else if (value.is("function"))
    ret = "<function>";

  return ret;
}
*/