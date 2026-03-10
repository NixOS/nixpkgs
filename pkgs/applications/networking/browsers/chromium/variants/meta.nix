lib: rec {
  chromium = {
    pname = "chromium";
    meta = {
      description = "Open source web browser from Google";
      longDescription = ''
        Chromium is an open source web browser from Google that aims to build a
        safer, faster, and more stable way for all Internet users to experience
        the web. It has a minimalist user interface and provides the vast majority
        of source code for Google Chrome (which has some additional features).
      '';
      homepage = "https://www.chromium.org";
      license = lib.licenses.bsd3;
      mainProgram = "chromium";
      # Maintainer pings for this derivation are highly unreliable.
      # If you add yourself as maintainer here, please also add yourself as CODEOWNER.
      maintainers = with lib.maintainers; [
        networkexception
        emilylange
      ];
    };
  };
  ungoogled = {
    pname = "ungoogled-chromium";
    meta = {
      description = chromium.meta.description + ", with dependencies on Google web services removed";
      homepage = "https://github.com/ungoogled-software/ungoogled-chromium";
      inherit (chromium.meta)
        longDescription
        license
        mainProgram
        maintainers
        ;
    };
  };
}
