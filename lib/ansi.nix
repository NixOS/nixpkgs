# This exports a basic set of ANSI escape sequences to colorize terminal output.

{ ... }:

let
  colorCodeMap = {
    black = 0;
    red = 1;
    green = 2;
    yellow = 3;
    blue = 4;
    magenta = 5;
    cyan = 6;
    white = 7;
  };

  # Escape character. "\e" or similar encodings currently not supported by Nix.
  esc = "";
  reset = "${esc}[0m";
  style = {
    bold = "${esc}[1m";
    italic = "${esc}[3m";
  };
  # Only foreground colors are supported at the moment.
  color = builtins.mapAttrs (name: value: "${esc}[3${toString value}m") colorCodeMap;

  /* Stylizes a string with ANSI escape sequences.

     Type: stylize :: [String] -> String -> String
  */
  stylize =
    # List of ANSI style attributes.
    styles:
    # Text to encapsulate by style.
    text:
    let
      ansiBefore = builtins.concatStringsSep "" styles;
    in
    if text == ""
    then ""
    else "${ansiBefore}${text}${reset}";

  /* Stylizes a string as bold and red.

     Type: stylizeError :: String -> String
  */
  stylizeError = text: stylize [ style.bold color.red ] text;

  /* Stylizes a string as bold and yellow.

     Type: stylizeWarn :: String -> String
  */
  stylizeWarn = text: stylize [ style.bold color.yellow ] text;
in
{
  inherit color style reset;
  inherit stylize stylizeError stylizeWarn;
}
