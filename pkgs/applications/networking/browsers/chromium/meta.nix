{ lib
, channel
, ungoogled
, headlessShell ? false
, enableWideVine
}:

{
  description = "An open source web browser from Google"
                + lib.optionalString ungoogled ", with dependencies on Google web services removed";
  longDescription = ''
      Chromium is an open source web browser from Google that aims to build a
      safer, faster, and more stable way for all Internet users to experience
      the web. It has a minimalist user interface and provides the vast majority
      of source code for Google Chrome (which has some additional features).
    '';
  homepage = if ungoogled
             then "https://github.com/Eloston/ungoogled-chromium"
             else "https://www.chromium.org/";
  maintainers = with lib.maintainers; if headlessShell
                                      then [ thomasjm ]
                                      else if ungoogled
                                      then [ squalus primeos michaeladler ]
                                      else [ primeos thefloweringash ];
  license = if enableWideVine then lib.licenses.unfree else lib.licenses.bsd3;
  platforms = lib.platforms.linux;
  mainProgram = "chromium";
  hydraPlatforms = if (channel == "stable" || channel == "ungoogled-chromium")
                   then ["aarch64-linux" "x86_64-linux"]
                   else [];
  timeout = 172800; # 48 hours (increased from the Hydra default of 10h)
}
