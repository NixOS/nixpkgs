{ lib, stdenv
<<<<<<< HEAD
, fetchFromGitHub
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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
=======
{

grimshot = stdenv.mkDerivation rec {
  pname = "grimshot";
  version = sway-unwrapped.version;

  src = sway-unwrapped.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontBuild = true;
  dontConfigure = true;

  outputs = [ "out" "man" ];

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper installShellFiles ];
  buildInputs = [ bash ];
  installPhase = ''
<<<<<<< HEAD
    installManPage grimshot.1

    install -Dm 0755 grimshot $out/bin/grimshot
=======
    installManPage contrib/grimshot.1

    install -Dm 0755 contrib/grimshot $out/bin/grimshot
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ evils ];
    mainProgram = "grimshot";
=======
    homepage = "https://github.com/swaywm/sway/tree/master/contrib";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = sway-unwrapped.meta.maintainers ++ (with maintainers; [ evils ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
};


inactive-windows-transparency = python3Packages.buildPythonApplication rec {
<<<<<<< HEAD
  inherit version src;

  # long name is long
  lname = "inactive-windows-transparency";
  pname = "sway-${lname}";
=======
  # long name is long
  lname = "inactive-windows-transparency";
  pname = "sway-${lname}";
  version = sway-unwrapped.version;

  src = sway-unwrapped.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "other";
  dontBuild = true;
  dontConfigure = true;

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  installPhase = ''
<<<<<<< HEAD
    install -Dm 0755 $src/${lname}.py $out/bin/${lname}.py
  '';

  meta = with lib; {
    description = "It makes inactive sway windows transparent";
    mainProgram = "${lname}.py";
    maintainers = with maintainers; [
      evils # packaged this as a side-effect of grimshot but doesn't use it
    ];
=======
    install -Dm 0755 $src/contrib/${lname}.py $out/bin/${lname}.py
  '';

  meta = sway-unwrapped.meta // {
    description = "It makes inactive sway windows transparent";
    homepage    = "https://github.com/swaywm/sway/tree/${sway-unwrapped.version}/contrib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
};

}
