/**
 * fetcher implementation for https dependencies
 */

import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  PathString,
} from "../types.d.ts";
import { fetchCommon } from "./fetch-common.ts";

export async function fetchAllHttps(
  outPathPrefix: PathString,
  commonLockfileHttps: CommonLockFormatIn,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved = commonLockfileHttps.map((p) =>
    fetchCommon(outPathPrefix, p)
  );

  await Promise.all(resultUnresolved).then((packageFiles) => {
    const fixedUrlPackageFiles = packageFiles.map((p) => {
      // special case for esm.sh packages,
      // see readme.md -> `esm.sh`
      if (p?.meta?.original_url) {
        p.url = p.meta.original_url;
      }
      return p;
    });
    result = result.concat(fixedUrlPackageFiles);
  });
  return result;
}
