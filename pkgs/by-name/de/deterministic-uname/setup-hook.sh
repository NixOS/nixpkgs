# PATH is overwritten after package setup hooks are run,
# so the variable change needs to be delayed until a phase.
# An entry in prePhases is the earliest possible, useful
# in case an unpack or patch hook attempts to run uname.
unamePreHook() {
  export PATH="@out@/bin:$PATH"
}
appendToVar prePhases unamePreHook
