{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, makeDesktopItem
, copyDesktopItems
, imagemagick
, libX11
, libICE
, libSM
, fontconfig
, ...
}:

let
  owner = "yatli";
  repo = "fvim";
in
buildDotnetModule rec {
  pname = "fvim";
  version = "0.3.548";
  tag = "v${version}+g2e4087d";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = tag;
    hash = "sha256-ldnSkcyukxgpDdPhxZiMF+rHsZgdkFmUz0GgoLDZkDc=";
  };

  projectFile = "fvim.fsproj";
  executables = [ "FVim" ];
  nugetDeps = ./deps.nix;

  dotnetBuildFlags = [ "--no-self-contained" ];
  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
    "-p:PublishTrimmed=false"
    "-p:PublishReadyToRun=false"
  ];
  dotnet-sdk = dotnetCorePackages.sdk_6_0;

  runtimeDeps = [
    libX11
    libICE
    libSM
    fontconfig
  ];

  postInstall = ''
    for size in 16 24 32 48 64 128 256; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" ${src}/Assets/fvim.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
    done
  '';

  postFixup = ''
    mv $out/bin/FVim $out/bin/fvim
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = "${pname} %F";
      desktopName = "FVim";
      comment = meta.description;
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      startupNotify = false;
      terminal = false;
      mimeTypes = [
        "application/x-shellscript"
        "text/english"
        "text/plain"
        "text/x-c"
        "text/x-c++"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-makefile"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
      ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  meta = with lib; {
    homepage = "https://github.com/${owner}/${repo}";
    changelog = "https://github.com/${owner}/${repo}/releases/tag/${tag}";
    description = " Cross platform Neovim front-end UI, built with F# + Avalonia";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ ners ];
  };
}
