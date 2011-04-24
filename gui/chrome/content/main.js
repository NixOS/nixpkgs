// global variables.
var gNixOS;
var gOptionView;

/*
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
*/

function updatePanel(options)
{
  log("updatePanel: " + options.length);
  if (options.length == 0)
    return;
  // FIXME: ignore the rest of the selection for now.
  var o = options[0];
  $("#name").attr("label", o.path);

  if (o.typename != null)
    $("#typename").attr("label", o.typename);
  else
    $("#typename").attr("label", "");

  $("#desc").text(o.description);

  if (o.value != null)
    $("#val").text(o.value);
  else
    $("#val").text("");

  if (o.defaultValue != null)
    $("#def").text(o.defaultValue);
  else
    $("#def").text("");

  if (o.example != null)
    $("#exp").text(o.example);
  else
    $("#exp").text("");

  $("#decls").text(o.declarations.join("\n"));
  $("#defs").text(o.definitions.join("\n"));
}


function onload()
{
  var optionTree = document.getElementById("option-tree");
  // gProgressBar = document.getElementById("progress-bar");
  // setProgress(0, 1);

  gNixOS = new NixOS();
  gOptionView = new OptionView(gNixOS.option, updatePanel);
  optionTree.view = gOptionView;
}
