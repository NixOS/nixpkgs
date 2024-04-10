{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goread";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "TypicalAM";
    repo = "goread";
    rev = "v${version}";
    hash = "sha256-m6reRaJNeFhJBUatfPNm66LwTXPdD/gioT8HTv52QOw=";
  };

  vendorHash = "sha256-/kxEnw8l9S7WNMcPh1x7xqiQ3L61DSn6DCIvJlyrip0=";

  doCheck = false;
  # Tests require network access, not available in Nix builds.
  # See https://github.com/TypicalAM/goread/issues/45

  meta = with lib; {
    description = "Beautiful program to read your RSS/Atom feeds right in the terminal!";
    homepage = "https://github.com/TypicalAM/goread";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "goread";
    descriptionLong = ''
      goread is an RSS/Atom feed reader for the terminal. It allows you to categorize and follow feeds and read articles right in the commandline! It's accompanied by a beautiful TUI made with bubble tea. Features include:
      - Categorizing feeds
      - Downloading articles for later use
      - Offline mode
      - Customizable colorschemes
      - OPML file support
      - A nice and simple TUI
    '';
  };
}
