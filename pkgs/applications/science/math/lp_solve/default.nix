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

  src = fetchurl {
    url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_source.tar.gz";
    sha256 = "sha256-bUq/9cxqqpM66ObBeiJt8PwLZxxDj2lxXUHQn+gfkC8=";
  };

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

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -d -m755 $out/bin $out/lib $out/include/lpsolve
    install -m755 lp_solve/bin/*/lp_solve -t $out/bin
    install -m644 lpsolve55/bin/*/liblpsolve* -t $out/lib
    install -m644 lp_*.h -t $out/include/lpsolve

    rm $out/lib/liblpsolve*.a
    rm $out/include/lpsolve/lp_solveDLL.h  # A Windows header

    runHook postInstall
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
