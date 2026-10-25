{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  makeWrapper,
  cacert,
}:

with python3Packages;

stdenv.mkDerivation (finalAttrs: {
  pname = "google-app-engine-go-sdk";
  version = "1.9.61";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${finalAttrs.version}.zip";
        sha256 = "1i2j9ympl1218akwsmm7yb31v0gibgpzlb657bcravi1irfv1hhs";
      }
    else
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-${finalAttrs.version}.zip";
        sha256 = "0s8sqyc72lnc7dxd4cl559gyfx83x71jjpsld3i3nbp3mwwamczp";
      };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python ];

  installPhase = ''
    mkdir -p $out/bin $out/share/
    cp -r "$src" "$out/share/go_appengine"

    for f in lib/cacerts/cacerts.txt lib/cacerts/urlfetch_cacerts.txt \
      lib/httplib2/httplib2/cacerts.txt lib/requests/requests/cacert.pem; do
      chmod u+w "$(dirname "$out/share/go_appengine/$f")"
      rm "$out/share/go_appengine/$f"
      ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt "$out/share/go_appengine/$f"
    done

    # create wrappers with correct env
    for i in goapp go-app-stager *.py; do
      makeWrapper "$out/share/go_appengine/$i" "$out/bin/$i" \
        --prefix PATH : "${python}/bin" \
        --prefix PYTHONPATH : "$(toPythonPath ${cffi}):$(toPythonPath ${cryptography}):$(toPythonPath ${pyopenssl})"
    done
  '';

  meta = {
    description = "Google App Engine SDK for Go";
    version = finalAttrs.version;
    homepage = "https://cloud.google.com/appengine/docs/go/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # includes golang toolchain binaries
    ];
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ lufia ];
  };
})
