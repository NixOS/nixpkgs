{ lib
, stdenv
, cmake
, fetchFromGitHub
, testers
, texinfo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjs-ng";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4nFc9xdxrfRWeOY9VNQAI4Ph7G1GMnw06XZiO6xA72o=";
  };

  outputs = [ "bin" "out" "dev" "doc" "info" ];

  nativeBuildInputs = [
    cmake
    texinfo
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    (lib.cmakeBool "BUILD_STATIC_QJS_EXE" stdenv.hostPlatform.isStatic)
  ];

  postInstall = ''
    (cd ../doc
     makeinfo --output quickjs.info quickjs.texi
     install -Dt $info/share/info/ quickjs.info)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "qjs --help || true";
    };
  };

  meta = with lib; {
    description = "A mighty JavaScript engine";
    homepage = "https://github.com/quickjs-ng/quickjs";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    platforms = platforms.all;
    mainProgram = "qjs";
  };
})
