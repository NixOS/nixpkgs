{
  fetchFromGitHub,
  stdenv,
  lib,
  python3,
  nix-update-script,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ac-library";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "atcoder";
    repo = "ac-library";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1wwzN/JPS6daj1vDFuEN5z20tMdLfMvEKti0sxCVlHA=";
  };

  outputs = [
    "dev"
    "out"
  ];

  buildInputs = [
    python3
  ];

  nativeInstallCheckInputs = [
    python3.pkgs.pytest
    cmake
  ];

  dontUseCmakeConfigure = true;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    substituteInPlace test/test_expander.py \
      --replace-fail "g++" "$CXX"
    python -m pytest --ignore-glob='test/unittest/googletest/*'

    pushd test/unittest
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_STANDARD=$STDCXX
    make
    ctest -VV
    popd

    runHook postInstallCheck
  '';

  # We don't need -fno-strict-overflow because it will break UBSanitize's overflow check especially when the operation number is static definded.
  hardeningDisable = [ "strictoverflow" ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=array-bounds"
      "-Wno-character-conversion"
    ];
  };

  installPhase = ''
    runHook preInstall

    install -d $dev/include/atcoder
    install -m644 atcoder/* $dev/include/atcoder/
    install -Dm755 expander.py $out/bin/expander

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official library of AtCoder";
    homepage = "https://github.com/atcoder/ac-library";
    license = lib.licenses.cc0;
    changelog = "https://github.com/atcoder/ac-library/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.all;
  };
})
