{ lib, stdenv
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
, bash

, python3Packages
}:

let
  version = "unstable-2023-06-30";
  src = fetchFromGitHub {
    owner = "OctopusET";
    repo = "sway-contrib";
    rev = "7e138bfc112872b79ac9fd766bc57c0f125b96d4";
    hash = "sha256-u4sw1NeAhl4FJCG2YOeY45SHoN7tw6cSJwEL5iqr0uQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/OctopusET/sway-contrib";
    license = licenses.mit;
    platforms = platforms.all;
  };
in
{

grimshot = stdenv.mkDerivation rec {
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

  meta = with lib; {
    description = "A helper for screenshots within sway";
    maintainers = with maintainers; [ evils ];
    mainProgram = "grimshot";
  };
};


inactive-windows-transparency = python3Packages.buildPythonApplication rec {
  inherit version src;

  # long name is long
  lname = "inactive-windows-transparency";
  pname = "sway-${lname}";

  format = "other";
  dontBuild = true;
  dontConfigure = true;

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  installPhase = ''
    install -Dm 0755 $src/${lname}.py $out/bin/${lname}.py
  '';

  meta = with lib; {
    description = "It makes inactive sway windows transparent";
    mainProgram = "${lname}.py";
    maintainers = with maintainers; [
      evils # packaged this as a side-effect of grimshot but doesn't use it
    ];
  };
};

}
