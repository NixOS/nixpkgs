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

function updateTextbox(id, value)
{
  // setting the height cause an overflow which resize the textbox to its
  // content due to its onoverflow attribute.
  $(id).attr("value", value).attr("height", 1);
};

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
    updateTextbox("#val", o.value);
  else
    updateTextbox("#val", "");

  if (o.defaultValue != null)
    updateTextbox("#def", o.defaultValue);
  else
    updateTextbox("#def", "");

  if (o.example != null)
    updateTextbox("#exp", o.example);
  else
    updateTextbox("#exp", "");

  updateTextbox("#decls", o.declarations.join("\n"));
  updateTextbox("#defs", o.definitions.join("\n"));
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
