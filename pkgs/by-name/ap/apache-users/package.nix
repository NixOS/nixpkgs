{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apache-users";
  version = "2.1";

  src = fetchurl {
    url = "https://labs.portcullis.co.uk/download/apache_users-${finalAttrs.version}.tar.gz";
    hash = "sha256-rylW4F8Si6KKYxaxEJlVFnbLqfqS6ytMPfHpc8MgriA=";
  };

  # Allow optional arguments where defaults are provided
  patches = [ ./optional-args.patch ];

  postPatch = ''
    substituteAllInPlace apache${finalAttrs.version}.pl
  '';

  buildInputs = [
    (perl.withPackages (p: [
      p.ParallelForkManager
      p.LWP
    ]))
  ];

  installPhase = ''
    runHook preInstall

    install -D apache${finalAttrs.version}.pl $out/bin/apache-users
    install -Dm444 names $out/share/apache-users/names

    runHook postInstall
  '';

  meta = with lib; {
    description = "Username Enumeration through Apache UserDir";
    homepage = "https://labs.portcullis.co.uk/downloads/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ emilytrau ];
    mainProgram = "apache-users";
  };
})
