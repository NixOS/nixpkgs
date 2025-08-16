{
  ruby,
  lib,
  bundlerApp,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerApp {
  pname = "mailcatcher";
  gemdir = ./.;
  exes = [
    "mailcatcher"
    "catchmail"
  ];

  passthru.updateScript = bundlerUpdateScript "mailcatcher";
  passthru.tests = { inherit (nixosTests) mailcatcher; };

  meta = {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage = "https://mailcatcher.me/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zarelit
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
