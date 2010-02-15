(* ========================================================================= *)
(* Create a standalone HOL image. Assumes that we are running under Linux    *)
(* and have the program "dmtcp" available to create checkpoints.             *)
(*                                                                           *)
(*              (c) Copyright, John Harrison 1998-2007                       *)
(*              (c) Copyright, Marco Maggesi 2010                            *)
(* ========================================================================= *)

#use "make.ml";;

(* ------------------------------------------------------------------------- *)
(* Non-destructive checkpoint using DMTCP.                                   *)
(* ------------------------------------------------------------------------- *)

let checkpoint bannerstring =
  let longer_banner = startup_banner ^ " with DMTCP" in
  let complete_banner =
    if bannerstring = "" then longer_banner
    else longer_banner^"\n        "^bannerstring in
  (Gc.compact();
   loadt "Examples/update_database.ml";
   print_newline ();
   Unix.sleep 1;
   try ignore(Unix.system ("dmtcp_command -bc")) with _ -> ();
   Format.print_string complete_banner;
   Format.print_newline(); Format.print_newline());;

dmtcp_checkpoint "";;