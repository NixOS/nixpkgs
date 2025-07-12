{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  nautilus-python,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "insync-nautilus";
  version = "3.9.5.60024";
  pyproject = true;

  # Download latest from: https://www.insynchq.com/downloads/linux#nautilus
  src = fetchurl rec {
    urls = [
      "https://cdn.insynchq.com/builds/linux/${finalAttrs.version}/insync-nautilus_${finalAttrs.version}_all.deb"
      "https://web.archive.org/web/20250502162242/${builtins.elemAt urls 0}"
    ];
    hash = "sha256-yfPZ58xWZknpCqE8cJ7e7fR4+nzsCdprgBFRL0U0LvM=";
  };

  nativeBuildInputs = [ dpkg ];

  buildInputs = [ nautilus-python ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out

    runHook postInstall
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hellwolf ];
    homepage = "https://www.insynchq.com";
    description = "This package contains the Python extension and icons for integrating Insync with Nautilus";
  };
})
