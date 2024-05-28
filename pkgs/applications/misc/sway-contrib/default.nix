{ lib, stdenvNoCC
, fetchFromGitHub
, coreutils
, makeWrapper
, sway-unwrapped
, installShellFiles
, wl-clipboard
, libnotify
, slurp
, grim
, jq
, gnugrep
, bash

, python3Packages
}:

let
  version = "0-unstable-2024-01-20";
  src = fetchFromGitHub {
    owner = "OctopusET";
    repo = "sway-contrib";
    rev = "b7825b218e677c65f6849be061b93bd5654991bf";
    hash = "sha256-ZTfItJ77mrNSzXFVcj7OV/6zYBElBj+1LcLLHxBFypk=";
  };

  meta = with lib; {
    homepage = "https://github.com/OctopusET/sway-contrib";
    license = licenses.mit;
    platforms = platforms.all;
  };
in
{

grimshot = stdenvNoCC.mkDerivation {
  inherit version src;

  pname = "grimshot";

  dontBuild = true;
  dontConfigure = true;

  outputs = [ "out" "man" ];

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper installShellFiles ];
  buildInputs = [ bash ];
  installPhase = ''
    installManPage grimshot.1

    install -Dm 0755 grimshot $out/bin/grimshot
    wrapProgram $out/bin/grimshot --set PATH \
      "${lib.makeBinPath [
        sway-unwrapped
        wl-clipboard
        coreutils
        libnotify
        slurp
        grim
        jq
        gnugrep
        ] }"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    # check always returns 0
    if [[ $($out/bin/grimshot check | grep "NOT FOUND") ]]; then false
    else
      echo "grimshot check passed"
    fi
  '';

  meta = with lib; meta // {
    description = "A helper for screenshots within sway";
    maintainers = with maintainers; [ evils ];
    mainProgram = "grimshot";
  };
};


inactive-windows-transparency = let
  # long name is long
  lname = "inactive-windows-transparency";
in python3Packages.buildPythonApplication {
  inherit version src;

  pname = "sway-${lname}";

  format = "other";
  dontBuild = true;
  dontConfigure = true;

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  installPhase = ''
    install -Dm 0755 $src/${lname}.py $out/bin/${lname}.py
  '';

  meta = with lib; meta // {
    description = "It makes inactive sway windows transparent";
    mainProgram = "${lname}.py";
    maintainers = with maintainers; [
      evils # packaged this as a side-effect of grimshot but doesn't use it
    ];
  };
};

}
