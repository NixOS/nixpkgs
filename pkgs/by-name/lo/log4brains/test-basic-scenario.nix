{
  testers,
  log4brains,
}:
testers.runCommand {
  name = "log4brains-test-basic-scenario";
  # the build runs for *quite* a while
  meta.timeout = 90;
  nativeBuildInputs = [ log4brains ];

  script = ''
    log4brains | grep 'Log4brains CLI'

    mkdir project && cd project

    log4brains init --defaults
    test -f docs/adr/index.md

    log4brains adr new --quiet 'Test ADR'
    grep -r 'Test ADR' docs/adr/ >/dev/null

    # Note: Preview is difficult to check (and hence not checked):
    # (1) It requires some timeout for the page to become ready.
    # (2) The signal & process handling is screwed; on kill the
    #     process serving in the background stays alive.

    log4brains build --out www
    test -f www/index.html
    grep -r 'Test ADR' www >/dev/null

    touch $out
  '';
}
