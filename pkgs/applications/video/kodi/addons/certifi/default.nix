{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  cacert,
}:
buildKodiAddon rec {
  pname = "certifi";
  namespace = "script.module.certifi";
  version = "2023.5.7";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-NQbjx+k9fnQMYLLMR5+N5NSuDcXEzZjlhGPA3qSmjfI=";
  };

  patches = [
    # Add support for NIX_SSL_CERT_FILE
    ./env.patch
  ];

  postPatch = ''
    # Use our system-wide ca-bundle instead of the bundled one
    ln -snvf "${cacert}/etc/ssl/certs/ca-bundle.crt" "lib/certifi/cacert.pem"
  '';

  propagatedNativeBuildInputs = [
    # propagate cacerts setup-hook to set up `NIX_SSL_CERT_FILE`
    cacert
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.certifi";
    };
  };

  meta = with lib; {
    homepage = "https://certifi.io";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.mpl20;
    teams = [ teams.kodi ];
  };
}
