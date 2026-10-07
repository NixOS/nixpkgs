{
  stdenv,
  fetchzip,
  firefox-bin,
  revision,
  system,
  throwSystem,
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "firefox";
      inherit revision;
    }).${system} or throwSystem;

  firefox-linux = stdenv.mkDerivation {
    name = "playwright-firefox";
    src = fetchzip {
      inherit (download) url stripRoot;
      hash =
        {
          x86_64-linux = "sha256-/jJgGzxaH1TD4iQyempHcrW63mN1FOqfH6ODv7CsWYI=";
          aarch64-linux = "sha256-TeM4JS8dR+G/01Kw+r1v5pAuAndNpiFpyt9AAHtrBpA=";
        }
        .${system} or throwSystem;
    };

    inherit (firefox-bin.unwrapped)
      nativeBuildInputs
      buildInputs
      runtimeDependencies
      appendRunpaths
      patchelfFlags
      ;

    buildPhase = ''
      mkdir -p $out/firefox
      cp -R . $out/firefox
    '';
  };
  firefox-darwin = fetchzip {
    inherit (download) url stripRoot;
    hash =
      {
        aarch64-darwin = "sha256-Yo+y0ISDe8/iG2MsbmZklTcz+HjdblO2lunrpejauks=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = firefox-linux;
  aarch64-linux = firefox-linux;
  aarch64-darwin = firefox-darwin;
}
.${system} or throwSystem
