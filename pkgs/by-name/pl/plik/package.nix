{
  buildGoModule,
  plikd,
}:

buildGoModule (finalAttrs: {
  pname = "plik";
  inherit (plikd)
    version
    src
    postPatch
    passthru
    ;

  subPackages = [ "client" ];

  vendorHash = null;

  postInstall = ''
    mv $out/bin/client $out/bin/plik
  '';

  meta = {
    inherit (plikd.meta)
      description
      homepage
      license
      maintainers
      ;
    mainProgram = "plik";
  };
})
