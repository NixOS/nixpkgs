{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "albanian-accents";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  meta = {
    description = "Useful for typing Albanian accented characters. Typically it is quite difficult to find an albanian keyboard. But in the end, there are just four accented characters, also, the \"w\" character is not part of our alfabet, and the replaces I'm using make sense for the characters getting replaced, and I can not find examples in english at least where they are used. So I hope this implementation will be helpful not only for me, but also for other . (e.g. ww + e -> ë and so on)";
    homepage = "https://github.com/fnosi/espanso-hub/tree/albanian-accents";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
