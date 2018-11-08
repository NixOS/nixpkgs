{ lib, bundlerApp, ruby }:

bundlerApp {
  pname = "taskjuggler";

  inherit ruby;
  gemdir = ./.;

  exes = [
    "tj3" "tj3client" "tj3d" "tj3man" "tj3ss_receiver" "tj3ss_sender"
    "tj3ts_receiver" "tj3ts_sender" "tj3ts_summary" "tj3webd"
  ];

  meta = {
    description = "A modern and powerful project management tool";
    homepage    = http://taskjuggler.org/;
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.manveru ];
  };
}
