var COPYCOL = 2;
var gOptionListView = new treeView(["opt-success","opt-name","opt-desc"],
                                   COPYCOL);

// Run xulrunner application.ini -jsconsole -console, to see messages.
function log(str)
{
  Components.classes['@mozilla.org/consoleservice;1']
    .getService(Components.interfaces.nsIConsoleService)
    .logStringMessage(str);
}


// return the DOM of the value returned by nix-instantiate
function dumpOptions(path)
{
  var nixInstantiate = "nix-instantiate"; // "@nix@/bin/nix-instantiate";
  var nixos = "/etc/nixos/nixos/default.nix"; // "@nixos@/default.nix";

  var o = makeTempFile("nixos-options");

  path = "eval.options" + (path? "." + path : "");
  log("retrieve options from: " + path);

  runProgram(nixInstantiate+" "+nixos+" -A "+path+" --eval-only --strict --xml 2>/dev/null | tr -d '' >" + o.path);

  var xml = readFromFile(o);
  o.remove(false);

  // jQuery does a stack overflow when converting the XML to a DOM.
  var dom = DOMParser().parseFromString(xml, "text/xml");
  
  log("return dom");
  return dom;
}


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
      break
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

var gProgressBar;
function setProgress(current, max)
{
  if (gProgressBar) {
    gProgressBar.value = 100 * current / max;
    log("progress: " + gProgressBar.value + "%");
  }
  else
    log("unknow progress bar");
}

// fill the list of options
function setOptionList(optionDOM)
{
  var options = $("attrs", optionDOM).filter(function () {
    return $(this)
      .children("attr[name='_type']")
      .children("string[value='option']")
      .length != 0;
  });

  var max = options.length;

  log("Number of options: " + max);

  setProgress(0, max);
  gOptionListView.clear();
  options.each(function (index){
      var success = nixSelect(this, "config.success");
      var name = nixSelect(this, "name");
      var desc = nixSelect(this, "description");
      if (success && name && desc) {
        log("Add option '" + name + "' in the list.");
        gOptionListView.addRow([success, name, desc]);
      }
      else
        log("A problem occur while scanning an option.");
      setProgress(index + 1, max);
  });
}


function onload()
{
  var optionList = document.getElementById("option-list");
  gProgressBar = document.getElementById("progress-bar");
  setProgress(0, 1);
  optionList.view = gOptionListView;

  // try to avoid blocking the rendering, unfortunately this is not perfect.
  setTimeout(function (){
    setOptionList(dumpOptions("hardware"));}
  , 100);
}
