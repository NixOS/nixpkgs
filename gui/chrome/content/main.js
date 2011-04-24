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
  var t = "";
  for (var i = 0; i < options.length; i++)
  {
    log("Called with " + options[i].path);
    t += options[i].description;
  }
  $("#option-desc").text(t);
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
