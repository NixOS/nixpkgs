getTargetRole
getTargetRoleWrapper

export FC${role_post}=@named_fc@

# If unset, assume the default hardening flags.
# These are different for fortran.
: ${NIX_HARDENING_ENABLE="@fortran_hardening@"}
export NIX_HARDENING_ENABLE

unset -v role_post
