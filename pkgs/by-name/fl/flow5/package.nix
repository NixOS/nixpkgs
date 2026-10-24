{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  opencascade-occt,
  openblasCompat,
  gmsh,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "flow5";
  version = "7.55";

  src = fetchFromGitHub {
    owner = "techwinder";
    repo = "flow5";
    tag = "v${finalAttrs.version}";
    sha256 = "5NtYRIthJleYMHy0ZZt0TmCm0tNUqmMnmDd6PzIp6Ns=";
  };

  env.LC_ALL = "C.UTF-8";

  strictDeps = true;

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    opencascade-occt
    openblasCompat
    openblasCompat.dev
    gmsh
  ];

  preConfigure = ''
    mkdir include
    ln -s ${openblasCompat.dev}/include include/openblas

    for f in fl5-lib/fl5-lib.pro fl5-app/fl5-app.pro; do

      sed -i -E "/LIBS \+= -lopenblas$/a\\$(printf '\t')INCLUDEPATH += $PWD/include" $f

      substituteInPlace "$f" \
        --replace-fail "/usr/local/include/opencascade" "${opencascade-occt}/include/opencascade" \
        --replace-fail "/usr/local/lib" "${opencascade-occt}/lib" \
        --replace-fail "LIBS += -lopenblaso" "LIBS += -L${openblasCompat}/lib -lopenblaso" \
        --replace-fail "LIBS += -lopenblasp" "LIBS += -L${openblasCompat}/lib -lopenblasp" \
        --replace-fail "LIBS += -lopenblas" "LIBS += -L${openblasCompat}/lib -lopenblas"
    done

    for f in XFoil-lib/XFoil-lib.pro fl5-lib/fl5-lib.pro fl5-app/fl5-app.pro; do
      substituteInPlace "$f" \
        --replace-fail "PREFIX = /usr/local" "PREFIX = $out"
    done

    substituteInPlace fl5-app/fl5-app.pro \
      --replace-fail 'desktop.path = $$(HOME)/.local/share/applications' "desktop.path = $out/share/applications"
  '';

  meta = {
    description = "Potential flow solver with built-in pre- and post-processing functionalities";
    homepage = "https://flow5.tech/flow5.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "flow5";
    maintainers = with lib.maintainers; [ jdelacroix ];
    platforms = lib.platforms.linux;
  };
})
