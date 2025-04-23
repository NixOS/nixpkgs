aa_action() {
  STRING=$1
  shift
  $*
  rc=$?
  if [ $rc -eq 0 ] ; then
    aa_log_success_msg $"$STRING "
  else
    aa_log_failure_msg $"$STRING "
  fi
  return $rc
}

aa_log_success_msg() {
   [ -n "$1" ] && echo -n $1
   echo ": done."
}

aa_log_warning_msg() {
   [ -n "$1" ] && echo -n $1
   echo ": Warning."
}

aa_log_failure_msg() {
   [ -n "$1" ] && echo -n $1
   echo ": Failed."
}

aa_log_skipped_msg() {
   [ -n "$1" ] && echo -n $1
   echo ": Skipped."
}
