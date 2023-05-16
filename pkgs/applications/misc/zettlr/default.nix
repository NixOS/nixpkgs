<<<<<<< HEAD
{ callPackage, texlive }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; inherit texlive; })) {
  zettlr = {
    version = "2.3.0";
    hash = "sha256-3p9RO6hpioYF6kdGV+/9guoqxaPCJG73OsrN69SHQHk=";
  };
  zettlr-beta = {
    version = "3.0.0-beta.7";
    hash = "sha256-zIZaINE27bcjbs8yCGQ3UKAwStFdvhHD3Q1F93LrG4U=";
=======
{ appimageTools
, lib
, fetchurl
, texlive
, pandoc
}:

# Based on https://gist.github.com/msteen/96cb7df66a359b827497c5269ccbbf94 and joplin-desktop nixpkgs.
let
  pname = "zettlr";
  version = "2.3.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    sha256 = "sha256-3p9RO6hpioYF6kdGV+/9guoqxaPCJG73OsrN69SHQHk=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ texlive pandoc ];
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/Zettlr.desktop $out/share/applications/Zettlr.desktop
    install -m 444 -D ${appimageContents}/Zettlr.png $out/share/icons/hicolor/512x512/apps/Zettlr.png
    substituteInPlace $out/share/applications/Zettlr.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ tfmoraes ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
