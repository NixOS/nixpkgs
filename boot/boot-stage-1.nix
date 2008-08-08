# This Nix expression builds the script that performs the first stage
# of booting the system: it loads the modules necessary to mount the
# root file system, then calls /init in the root file system to start
# the second boot stage.  The closure of the result of this expression
# is supposed to be put into an initial RAM disk (initrd).

{ substituteAll, staticShell, klibcShrunk
, extraUtils, modulesClosure

, # Whether to find root device automatically using its label.
  autoDetectRootDevice
  
, # If not scanning, the root must be specified explicitly.  Actually,
  # stage 1 can mount multiple file systems.  This is necessary if,
  # for instance, /nix (necessary for stage 2) is on a different file
  # system than /.
  #
  # This is a list of {mountPoint, device|label} attribute sets, i.e.,
  # the format used by the fileSystems configuration option.  There
  # must at least be a file system for the / mount point in this list.
  fileSystems ? []

, # If scanning, we need a disk label.
  rootLabel

, # Whether the root device is read-only and should be made writable
  # through a unionfs.
  isLiveCD

, # Resume device. [major]:[minor]
  resumeDevice ? "ignore-this"
}:

let

  # !!! use XML; copy&pasted from upstart-jobs/filesystems.nix.
  mountPoints = map (fs: fs.mountPoint) fileSystems;
  devices = map (fs: if fs ? device then fs.device else "LABEL=" + fs.label) fileSystems;
  fsTypes = map (fs: if fs ? fsType then fs.fsType else "auto") fileSystems;
  optionss = map (fs: if fs ? options then fs.options else "defaults") fileSystems;

in

if !autoDetectRootDevice && mountPoints == [] then abort "You must specify the fileSystems option!" else

substituteAll {
  src = ./boot-stage-1-init.sh;
  
  isExecutable = true;
  
  inherit staticShell modulesClosure;
  
  inherit autoDetectRootDevice isLiveCD mountPoints devices fsTypes optionss resumeDevice;
  
  rootLabel = if autoDetectRootDevice then rootLabel else "";
  
  path = [
    extraUtils
    klibcShrunk
  ];
}
