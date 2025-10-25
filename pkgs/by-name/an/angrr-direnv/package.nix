{
  angrr,
  resholve,
}:

resholve.mkDerivation {
  pname = "angrr-direnv";
  inherit (angrr) version src;
  installPhase = ''
    runHook preInstall
    install -m400 -D ./direnv/angrr.sh $out/share/direnv/lib/angrr.sh
    runHook postInstall
  '';
  solutions.default = {
    scripts = [ "share/direnv/lib/angrr.sh" ];
    interpreter = "none";
    inputs = [ ]; # use external angrr from PATH
    fake = {
      function = [
        "has"
        "direnv_layout_dir"
        "log_error"
        "log_status"
      ];
      external = [
        "angrr"
      ];
    };
  };

  meta = {
    description = "Direnv integration library for angrr";
    inherit (angrr.meta)
      homepage
      license
      maintainers
      platforms
      ;
  };
}
