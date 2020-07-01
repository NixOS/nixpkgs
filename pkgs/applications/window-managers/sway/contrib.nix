{ stdenv

, fetchurl
, coreutils
, makeWrapper
, sway-unwrapped
, installShellFiles
, wl-clipboard
, libnotify
, slurp
, grim
, jq

, python3Packages
}:

{

grimshot = stdenv.mkDerivation rec {
  pname = "grimshot";
  version = "2020-05-08";
  rev = "b1d08db5f5112ab562f89564825e3e791b0682c4";

  # master has new fixes and features, and a man page
  # after sway-1.5 these may be switched to sway-unwrapped.src
  bsrc = fetchurl {
    url = "https://raw.githubusercontent.com/swaywm/sway/${rev}/contrib/grimshot";
    sha256 = "1awzmzkib8a7q5s78xyh8za03lplqfpbasqp3lidqqmjqs882jq9";
  };

  msrc = fetchurl {
    url = "https://raw.githubusercontent.com/swaywm/sway/${rev}/contrib/grimshot.1";
    sha256 = "191xxjfhf61gkxl3b0f694h0nrwd7vfnyp5afk8snhhr6q7ia4jz";
  };

  dontBuild = true;
  dontUnpack = true;
  dontConfigure = true;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    installManPage ${msrc}

    install -Dm 0755 ${bsrc} $out/bin/grimshot
    wrapProgram $out/bin/grimshot --set PATH \
      "${stdenv.lib.makeBinPath [
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

  meta = with stdenv.lib; {
    description = "A helper for screenshots within sway";
    homepage = "https://github.com/swaywm/sway/tree/master/contrib";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      sway-unwrapped.meta.maintainers
      evils
    ];
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
