{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  libxcursor,
}:

stdenvNoCC.mkDerivation {
  pname = "kaltsit-cursors";
  version = "1.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JohnSmith-dink";
    repo = "kaltsit-cursors";
    rev = "7ef139a6210fd8eb03d0296b624d71eaa3120589";
    hash = "sha256-SzFWd9ZWsw5QpLSyg0FvliRMJlQix2sC8yawdrkJts8=";
  };

  nativeBuildInputs = [ (python3.withPackages (ps: [ ps.pillow ])) ];

  nativeCheckInputs = [ libxcursor ];

  buildPhase = ''
    runHook preBuild

    python3 tools/build_theme.py --output build/Kaltsit

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    export XCURSOR_TEST_LIBRARY="${lib.getLib libxcursor}/lib/libXcursor.so.1"
    python3 -m unittest discover -s tests -v

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"
    cp -r build/Kaltsit "$out/share/icons/Kaltsit"

    runHook postInstall
  '';

  meta = {
    description = "Animated Arknights Kal'tsit Xcursor theme";
    homepage = "https://github.com/JohnSmith-dink/kaltsit-cursors";
    # The original cursor artwork has a specific non-commercial permission grant.
    # The conversion tools are MIT licensed; see LICENSE and LICENSE-MIT upstream.
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = [ lib.maintainers.JohnSmith-dink ];
    platforms = lib.platforms.linux;
  };
}
