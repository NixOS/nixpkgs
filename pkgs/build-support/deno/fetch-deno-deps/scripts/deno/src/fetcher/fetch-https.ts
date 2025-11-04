import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  PathString,
} from "../types.d.ts";
import { fetchDefault } from "./fetch-default.ts";

export async function fetchAllHttps(
  outPathPrefix: PathString,
  commonLockfileHttps: CommonLockFormatIn,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved = commonLockfileHttps.map((p) =>
    fetchDefault(outPathPrefix, p)
  );

  await Promise.all(resultUnresolved).then((packageFiles) => {
    const fixedUrlPackageFiles = packageFiles.map((p) => {
      // special case for esm.sh packages,
      // to fetch the files, we need to use the modified url with the `?target=denonext` query param
      // however for deno to later resolve the packages properly, we need the original url
      if (p?.meta?.original_url) {
        p.url = p.meta.original_url;
      }
      return p;
    });
    result = result.concat(fixedUrlPackageFiles);
  });
  return result;
}
