(* ========================================================================= *)
(* Create a standalone HOL image. Assumes that we are running under Linux    *)
(* and have the program "dmtcp" available to create checkpoints.             *)
(*                                                                           *)
(*              (c) Copyright, John Harrison 1998-2007                       *)
(*              (c) Copyright, Marco Maggesi 2010                            *)
(* ========================================================================= *)

(* Use this instead of #use "make.ml";; for quick tests. *)
(*
let a = 1;
#load "unix.cma";;
let startup_banner = "Bogus banner\n";;
Format.print_string "Hello!"; Format.print_newline();;
*)

#use "make.ml";;

(* ------------------------------------------------------------------------- *)
(* Checkpoint using DMTCP.                                                   *)
(* dmtcp_selfdestruct is similar to dmtcp_checkpoint but terminates          *)
(* HOL Light and shuts down the dmtcp coordinator.                           *)
(* ------------------------------------------------------------------------- *)

let dmtcp_checkpoint, dmtcp_selfdestruct =
  let call_dmtcp opts bannerstring =
    let longer_banner = startup_banner ^ " with DMTCP" in
    let complete_banner =
      if bannerstring = "" then longer_banner
      else longer_banner^"\n        "^bannerstring in
    (Gc.compact(); Unix.sleep 4;
     Format.print_string "Checkpointing..."; Format.print_newline();
     try ignore(Unix.system ("dmtcp_command -bc " ^ opts)) with _ -> ();
     Format.print_string complete_banner;
     Format.print_newline(); Format.print_newline())
  in
  call_dmtcp "", call_dmtcp "-q";;
