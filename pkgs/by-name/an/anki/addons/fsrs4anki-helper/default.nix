{
  lib,
  anki-utils,
  fetchFromGitHub,
  unstableGitUpdater,
  python3,
}:

anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "fsrs4anki-helper";
  version = "24.06.3-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "open-spaced-repetition";
    repo = "fsrs4anki-helper";
    rev = "8934a5d53caa68bf688e6b0964c36fb5a87970c0";
    hash = "sha256-2vDPEXfFeR7z8WMC96bSaDJ2nLN16dZicAVu1Nnq558=";
  };

  postFixup = ''
    rmdir $out/share/anki/addons/fsrs4anki-helper/python_i18n
    ln -s \
      ${python3.pkgs.python-i18n}/${python3.sitePackages} \
      $out/share/anki/addons/fsrs4anki-helper/python_i18n
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Anki add-on that supports the FSRS algorithm";
    longDescription = ''
      FSRS Helper is an Anki add-on that supports the FSRS algorithm. It has eight main features:

      - Reschedule cards based on their entire review histories.
      - Postpone a selected number of due cards.
      - Advance a selected number of undue cards.
      - Balance the load during rescheduling (based on fuzz).
      - Less Anki on Easy Days (such as weekends) during rescheduling (based on load balance).
      - Disperse Siblings (cards with the same note) to avoid interference & reminder.
      - Flatten future due cards to a selected number of reviews per day.
      - Steps Stats quantify your short-term memory performance and recommend learning steps.

      It can also be configured declaratively, as follows:

      ```nix
      pkgs.ankiAddons.fsrs4anki-helper.withConfig {
        config = {
          days_to_reschedule = 10;
          auto_reschedule_after_sync = true;
          display_memory_state = true;
        };
      }
      ```

      For a list of all configuration options, please refer to [config.md](https://github.com/open-spaced-repetition/fsrs4anki-helper/blob/${finalAttrs.src.rev}/config.md).
    '';
    homepage = "https://github.com/open-spaced-repetition/fsrs4anki-helper";
    downloadPage = "https://ankiweb.net/shared/info/759844606";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
