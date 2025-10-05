{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  coreutils,
  makeWrapper,
  sway-unwrapped,
  installShellFiles,
  wl-clipboard,
  libnotify,
  slurp,
  grim,
  jq,
  gnugrep,
  bash,

  python3Packages,
}:

let
  version = "1.11";
  src = fetchFromGitHub {
    owner = "OctopusET";
    repo = "sway-contrib";
    tag = version;
    hash = "sha256-/gWL0hA8hDjpK5YJxuZqmvo0zuVRQkhAkgHlI4JzNP8=";
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

    outputs = [
      "out"
      "man"
    ];

    strictDeps = true;
    nativeBuildInputs = [
      makeWrapper
      installShellFiles
    ];
    buildInputs = [ bash ];
    installPhase = ''
      installManPage grimshot/grimshot.1
      installShellCompletion --cmd grimshot grimshot/grimshot-completion.bash

      install -Dm 0755 grimshot/grimshot $out/bin/grimshot
      wrapProgram $out/bin/grimshot --set PATH \
        "${
          lib.makeBinPath [
            sway-unwrapped
            wl-clipboard
            coreutils
            libnotify
            slurp
            grim
            jq
            gnugrep
          ]
        }"
    '';

    doInstallCheck = true;

    installCheckPhase = ''
      # check always returns 0
      if [[ $($out/bin/grimshot check | grep "NOT FOUND") ]]; then false
      else
        echo "grimshot check passed"
      fi
    '';

    meta =
      with lib;
      meta
      // {
        description = "Helper for screenshots within sway";
        maintainers = with maintainers; [ evils ];
        mainProgram = "grimshot";
      };
  };

  inactive-windows-transparency =
    let
      # long name is long
      lname = "inactive-windows-transparency";
    in
    python3Packages.buildPythonApplication {
      inherit version src;

      pname = "sway-${lname}";

      format = "other";
      dontBuild = true;
      dontConfigure = true;

      propagatedBuildInputs = [ python3Packages.i3ipc ];

      installPhase = ''
        install -Dm 0755 $src/${lname}.py $out/bin/${lname}.py
      '';

      meta =
        with lib;
        meta
        // {
          description = "It makes inactive sway windows transparent";
          mainProgram = "${lname}.py";
          maintainers = with maintainers; [
            evils # packaged this as a side-effect of grimshot but doesn't use it
          ];
        };
    };

}
