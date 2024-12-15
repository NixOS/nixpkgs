{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  pname = "note";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "note";
    rev = "v1.0.0";
    hash = "sha256-ISYagWOW5EnjtP4oOO9Dia0oPexlgvul/yllrHeZceQ=";
  };
  vendorHash = "sha256-kzMvksDjhqKlHvBwl0spOApFKHKM7lm0WG2hifP6+Ro=";
  meta = {
    description = "A lightweight tool for capturing short-term notes";
    longDescription = ''
      This tool is designed for quick note-taking.
      It's perfect for jotting down temporary ideas or reminders from the command line without leaving any clutter.
    '';
    homepage = "https://github.com/NewDawn0/note";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
