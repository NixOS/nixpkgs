BEGIN {

  # ppd file keys are separated from their values by a colon,
  # but "options" may reside between the key name and the colon;
  # options are separated from the key by spaces
  # (we also permit tabs to be on the safe side)
  FS = "[: \t]";

  # escape regex characters in the old and new command strings
  gsub(/[]\\.^$(){}|*+?[]/, "\\\\&", old);
  gsub(/\\/, "\\\\&", new);
  # ...and surround old command with some regex
  # that singles out shell command invocations
  # to avoid replacing other strings that might contain the
  # command name by accident (like "perl" in "perl-script")
  new = "\\1" new "\\2";
  old = "(^|[;&| \\t\"`(])" old "($|[);&| \\t\"`<>])";
  # note that a similar regex is build in the shell script to
  # filter out unaffected files before this awk script is called;
  # if the regex here is changed, the shell script should also be checked

  # list of PPD keys that contain executable names or scripts, see
  # https://refspecs.linuxfoundation.org/LSB_4.0.0/LSB-Printing/LSB-Printing/ppdext.html
  # https://www.cups.org/doc/spec-ppd.html
  cmds["*APAutoSetupTool"] = "";
  cmds["*APPrinterLowInkTool"] = "";
  cmds["*FoomaticRIPCommandLine"] = "";
  cmds["*FoomaticRIPPostPipe"] = "";
  cmds["*cupsFilter"] = "";
  cmds["*cupsFilter2"] = "";
  cmds["*cupsPreFilter"] = "";

}

# since comments always start with "*%",
# this mechanism also properly recognizes (and ignores) them

{

  # if the current line starts a new key,
  # check if it is a command-containing key;
  # also reset the `isCmd` flag if a new file begins
  if ($0 ~ /^\*/ || FNR == 1)  { isCmd = ($1 in cmds) }

  # replace commands if the current keys might contain commands
  if (isCmd)  { $0 = gensub(old, new, "g") }

  print

}
