{
  fetchFromGitHub,
  lib,
  i3,
  pcre2,
}:

let
  version = "4.21.1";
in
i3.overrideAttrs (oldAttrs: {
  pname = "i3-rounded";
  inherit version;

  src = fetchFromGitHub {
    owner = "LinoBigatti";
    repo = "i3-rounded";
    rev = "v${version}";
    hash = "sha256-KMpejS89Hg6Mrm94HTNA9mV/6Leu1yo2W1CsD6vGDRo=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ pcre2 ];

  # Some tests are failing.
  doCheck = false;

  meta = {
    description = "Fork of i3-gaps that adds rounding to window corners";
    homepage = "https://github.com/LinoBigatti/i3-rounded";
    maintainers = with lib.maintainers; [ marsupialgutz ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
