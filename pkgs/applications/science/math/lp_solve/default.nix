{
  lib,
  stdenv,
  fetchurl,
  cctools,
  fixDarwinDylibNames,
  autoSignDarwinBinariesHook,
}:

stdenv.mkDerivation rec {
  pname = "lp_solve";
  version = "5.5.2.11";

  srcs = [
    (fetchurl {
      url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_source.tar.gz";
      sha256 = "sha256-bUq/9cxqqpM66ObBeiJt8PwLZxxDj2lxXUHQn+gfkC8=";
    })
    (fetchurl {
      url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_xli_CPLEX_source.tar.gz";
      sha256 = "sha256-iXTw+vw6eQK7OEA2C+N2UGaLEy0+iyTzi9FOGxLhFgI=";
    })
    (fetchurl {
      url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_xli_LINDO_source.tar.gz";
      sha256 = "sha256-k7dawG6ng7fVgHWbJyQhL9n/BUp04hn35RwsFdUs+YE=";
    })
    (fetchurl {
      url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_xli_MPS_source.tar.gz";
      sha256 = "sha256-RsohpMtpy/fD+1ygrqsM4EeK39UEAyxSv676KryDwtk=";
    })
    (fetchurl {
      url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_xli_XPRESS_source.tar.gz";
      sha256 = "sha256-ZbRgsl7jY8xsWIq12ohzRI6rALJj8iBpn4qVA6WLYIY=";
    })
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      fixDarwinDylibNames
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

  env =
    {
      NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int";
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
      NIX_LDFLAGS = "-headerpad_max_install_names";
    };

  dontConfigure = true;

  buildPhase =
    let
      ccc = if stdenv.hostPlatform.isDarwin then "ccc.osx" else "ccc";
    in
    ''
      runHook preBuild

      (cd lpsolve55 && bash -x -e ${ccc})
      (cd lp_solve  && bash -x -e ${ccc})

      (cd xli/xli_CPLEX  && bash -x -e ${ccc})
      (cd xli/xli_LINDO  && bash -x -e ${ccc})
      (cd xli/xli_MPS    && bash -x -e ${ccc})
      (cd xli/xli_XPRESS && bash -x -e ${ccc})

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -d -m755 $out/bin $out/lib $out/include/lpsolve
    install -m755 lp_solve/bin/*/lp_solve -t $out/bin
    install -m644 lpsolve55/bin/*/liblpsolve* -t $out/lib
    install -m644 xli/xli_CPLEX/bin/*/libxli_CPLEX.so -t $out/lib
    install -m644 xli/xli_LINDO/bin/*/libxli_LINDO.so -t $out/lib
    install -m644 xli/xli_MPS/bin/*/libxli_MPS.so -t $out/lib
    install -m644 xli/xli_XPRESS/bin/*/libxli_XPRESS.so -t $out/lib
    install -m644 lp_*.h -t $out/include/lpsolve

    rm $out/lib/liblpsolve*.a
    rm $out/include/lpsolve/lp_solveDLL.h  # A Windows header

    runHook postInstall
  '';

  postFixup = ''
    patchelf --add-rpath "$out/lib" "$out/bin/lp_solve"
  '';

  meta = with lib; {
    description = "Mixed Integer Linear Programming (MILP) solver";
    mainProgram = "lp_solve";
    homepage = "https://lpsolve.sourceforge.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms = platforms.unix;
  };
}
