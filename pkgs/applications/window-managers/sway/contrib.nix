{ lib, stdenv

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

{

grimshot = stdenv.mkDerivation rec {
  pname = "grimshot";
  version = sway-unwrapped.version;

  src = sway-unwrapped.src;

  dontBuild = true;
  dontConfigure = true;

  outputs = [ "out" "man" ];

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper installShellFiles ];
  buildInputs = [ bash ];
  installPhase = ''
    installManPage contrib/grimshot.1

    install -Dm 0755 contrib/grimshot $out/bin/grimshot
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
    homepage = "https://github.com/swaywm/sway/tree/master/contrib";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = sway-unwrapped.meta.maintainers ++ (with maintainers; [ evils ]);
  };
};


inactive-windows-transparency = python3Packages.buildPythonApplication rec {
  # long name is long
  lname = "inactive-windows-transparency";
  pname = "sway-${lname}";
  version = sway-unwrapped.version;

  src = sway-unwrapped.src;

  format = "other";
  dontBuild = true;
  dontConfigure = true;

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  installPhase = ''
    install -Dm 0755 $src/contrib/${lname}.py $out/bin/${lname}.py
  '';

  meta = sway-unwrapped.meta // {
    description = "It makes inactive sway windows transparent";
    homepage    = "https://github.com/swaywm/sway/tree/${sway-unwrapped.version}/contrib";
  };
};

}
