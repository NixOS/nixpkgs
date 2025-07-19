# This exports a basic set of ANSI escape sequences to colorize terminal output.

{ ... }:

let
  # Escape character. "\e" or similar encodings currently not supported by Nix.
  esc = "";
  reset = "${esc}[0m";
  style = {
    bold = "${esc}[1m";
    italic = "${esc}[3m";
  };
  colorCode = {
    black = 0;
    red = 1;
    green = 2;
    yellow = 3;
    blue = 4;
    magenta = 5;
    cyan = 6;
    white = 7;
  };
  color = {
    fg = builtins.mapAttrs (name: value: "${esc}[3${toString value}m") colorCode;
    bg = builtins.mapAttrs (name: value: "${esc}[4${toString value}m") colorCode;
  };

  /*
    Stylizes a string with ANSI escape sequences.

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
    if text == "" then "" else "${ansiBefore}${text}${reset}";

  /*
    Stylizes a string as bold and red.

    Type: stylizeError :: String -> String
  */
  stylizeError = text: stylize [ style.bold color.fg.red ] text;

  /*
    Stylizes a string as bold and yellow.

    Type: stylizeWarn :: String -> String
  */
  stylizeWarn = text: stylize [ style.bold color.fg.yellow ] text;
in
{
  inherit color style reset;
  inherit stylize stylizeError stylizeWarn;
}
