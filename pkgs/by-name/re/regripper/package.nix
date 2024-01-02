{ lib
, stdenv
, fetchFromGitHub
, perl
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "regripper";
  version = "unstable-2023-07-23";

  src = fetchFromGitHub {
    owner = "keydet89";
    repo = "RegRipper3.0";
    rev = "cee174fb6f137b14c426e97d17945ddee0d31051";
    sha256 = "sha256-vejIRlcVjxQJpxJabJJcljODYr+lLJjYINVtAPObvkQ=";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace rip.pl rr.pl \
      --replace \"plugins/\" \"$out/share/regripper/plugins/\"
    substituteInPlace rip.pl rr.pl \
      --replace \"plugins\" \"$out/share/regripper/plugins\"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    rm -r *.md *.exe *.bat *.dll

    cp -aR . "$out/share/regripper/"

    cat > "$out/bin/${pname}" << EOF
    #!${runtimeShell}
    exec ${perl}/bin/perl $out/share/regripper/rip.pl "\$@"
    EOF

    chmod u+x  "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source forensic software used as a Windows Registry data extraction command line";
    mainProgram = "regripper";
    homepage = "https://github.com/keydet89/RegRipper3.0";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
  };
}
