#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>

static const char libsane_smfp_cfg[] = "/opt/smfp-common/scanner/share/libsane-smfp.cfg";
static const char libsane_smfp_cfg_to[] = "@libsane_smfp_cfg_to@";

static const char smfp_conf[] = "/etc/sane.d/smfp.conf";
static const char smfp_conf_to[] = "@smfp_conf_to@";

static const char usedby[] = "/opt/smfp-common/scanner/.usedby/";
static const char usedby_to[] = "@usedby_to@";

static const char oem[] = "/opt/smfp-common/scanner/share/oem.conf";
static const char oem_to[] = "@oem_to@";

static const char sane_d[] = "/etc/sane.d";
static const char sane_d_to[] = "@sane_d_to@";

static const char opt[] = "/opt";
static const char opt_to[] = "@opt_to@";


const char* pick_path(const char* path)
{
  if (!strcmp(path, libsane_smfp_cfg)) {
    return libsane_smfp_cfg_to;
  } else if (!strcmp(path, smfp_conf)) {
    return smfp_conf_to;
  } else if (!strcmp(path, usedby)) {
    return usedby_to;
  } else if (!strcmp(path, oem)) {
    return oem_to;
  } if (!strcmp(path, sane_d)) {
    return sane_d_to;
  } if (!strcmp(path, opt)) {
    return opt_to;
  }
  return path;
}

FILE *fopen_wrapper(const char* file_name, const char* mode)
{
  return fopen(pick_path(file_name), mode);
}

DIR *opendir_wrapper(const char* dirname)
{
  return opendir(pick_path(dirname));
}
