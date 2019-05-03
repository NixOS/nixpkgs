{ lib, bundlerApp }:

bundlerApp {
  pname = "taskjuggler";
  gemdir = ./.;

  exes = [
    "tj3" "tj3client" "tj3d" "tj3man" "tj3ss_receiver" "tj3ss_sender"
    "tj3ts_receiver" "tj3ts_sender" "tj3ts_summary" "tj3webd"
  ];

  meta = with lib; {
    description = "A modern and powerful project management tool";
    homepage    = http://taskjuggler.org/;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.manveru ];
  };
}
