(* ------------------------------------------------------------------------- *)
(* Create a standalone HOL image. Assumes that we are running under Linux    *)
(* and have the program "dmtcp" available to create checkpoints.             *)
(* ------------------------------------------------------------------------- *)

let dmtcp_checkpoint, dmtcp_selfdestruct =
  let call_dmtcp opts bannerstring =
    let longer_banner = startup_banner ^ " with DMTCP" in
    let complete_banner =
      if bannerstring = "" then longer_banner
      else longer_banner^"\n        "^bannerstring in
    (Gc.compact(); Unix.sleep 1;
     Format.print_string "Checkpointing..."; Format.print_newline();
     try ignore(Unix.system ("dmtcp_command -bc " ^ opts))
     with Unix.Unix_error _ -> ();
     Format.print_string complete_banner;
     Format.print_newline(); Format.print_newline())
  in
  call_dmtcp "", call_dmtcp "-q";;
