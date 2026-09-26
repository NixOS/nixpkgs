{
  lib,
  stdenv,
  llvmPackages_18,
  fetchFromGitLab,
  cmake,
  python3,
  cef-binary_141_0_10,
  grayjay,
  libx11,
}:

llvmPackages_18.stdenv.mkDerivation (finalAttrs: {
  pname = "${grayjay.pname}-justcef";
  version = "1";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "JustCef";
    rev = "b1b5680ce42b4fd1c36070d28bbd6766ba2bae33";
    # Will otherwise download tarball containing vendored LFS files (~6GB)
    forceFetchGit = true;
    hash = "sha256-kpKJQJPZI244zIynyagUj2kSZS8T4ftsJf3LgU8eCC8=";
  };

  patches = [ ./0001-skip-clang-format-download.patch ];

  cefRootDir = "native/third_party/cef/${cef-binary_141_0_10.passthru.cefDistName}";

  postPatch = ''
    mkdir -p "$(dirname "$cefRootDir")"
    cp -r --no-preserve=mode,ownership ${cef-binary_141_0_10} "$cefRootDir"
    chmod -R u+w "$cefRootDir"
  '';

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;
  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [ libx11 ];

  cmakeDir = "../native";

  installPhase = ''
    runHook preInstall

    chmod +x Release/dotcefnative
    ln -s dotcefnative Release/justcefnative
    cp -r Release "$out"

    runHook postInstall
  '';

  meta = {
    description = "JustCef native CEF client (dotcefnative) used by Grayjay, built from source against pkgs.cef-binary";
    homepage = "https://gitlab.futo.org/videostreaming/JustCef";
    inherit (grayjay.meta) license maintainers;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
