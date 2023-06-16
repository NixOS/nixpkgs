{ lib, stdenv, autoPatchelfHook, fetchurl, dpkg, makeWrapper, fontconfig, zlib, libcxx, icu, openssl, libX11, libICE, libSM }:

stdenv.mkDerivation rec {
  pname = "git-credential-manager";
  version = "2.1.2";

  src = fetchurl {
    url = "https://github.com/git-ecosystem/git-credential-manager/releases/download/v${version}/gcm-linux_amd64.${version}.deb";
    sha256 = "sha256-H9VSlY2+MDgUTucttr5mVz+CNrDGhruE1sD5cbKrBqQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper ];
  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $src .";

  buildInputs = [
    fontconfig
    zlib
    libcxx
    icu
    openssl
    libX11
    libICE
    libSM
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "usr/local/share" "$out/share"
    chmod -R g-w "$out"

    makeWrapper $out/share/gcm-core/git-credential-manager $out/bin/git-credential-manager \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
    makeWrapper $out/share/gcm-core/git-credential-manager $out/bin/git-credential-manager-core \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.";
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    changelog = "https://github.com/git-ecosystem/git-credential-manager/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = [ maintainers.wrmilling ];
    platforms = [ "x86_64-linux" ];
  };
}
