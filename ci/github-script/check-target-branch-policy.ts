import { classify, split } from './supportedBranches.js'

type TargetBranchPolicyFacts = {
  base: string
  head: string
  maxRebuildCount: number
  rebuildsAllTests: boolean
  onlyChangedFile: string | null
}

type TargetBranchReviewDecision =
  | 'mass-rebuild'
  | 'nixos-rebuild'
  | 'possible-mass-rebuild'
  | 'skip-development-merge'
  | 'dismiss'

type TargetBranchPolicyResult = {
  decision: TargetBranchReviewDecision
  details: {
    isExemptKernelUpdate: boolean
    isExemptHomeAssistantUpdate: boolean
  }
}

export function getTargetBranchPolicy({
  base,
  head,
}: {
  base: string
  head: string
}) {
  const baseClassification = classify(base)
  const headClassification = classify(head)
  const isPrimaryBase = baseClassification.type.includes('primary')
  const isPrimaryHead = headClassification.type.includes('primary')
  const isStagingNixosBase = split(base).prefix === 'staging-nixos'
  const isDevelopmentHead = headClassification.type.includes('development')
  const shouldSkipDevelopmentMerge =
    isDevelopmentHead && (!isStagingNixosBase || isPrimaryHead)

  return {
    isStagingNixosBase,
    shouldSkipDevelopmentMerge,
    shouldCheckMassRebuild:
      !shouldSkipDevelopmentMerge && (isPrimaryBase || isStagingNixosBase),
    shouldCheckNixosRebuild: !shouldSkipDevelopmentMerge && isPrimaryBase,
  }
}

export function evaluateTargetBranchPolicy({
  base,
  head,
  maxRebuildCount,
  rebuildsAllTests,
  onlyChangedFile,
}: TargetBranchPolicyFacts): TargetBranchPolicyResult {
  const {
    isStagingNixosBase,
    shouldSkipDevelopmentMerge,
    shouldCheckMassRebuild,
    shouldCheckNixosRebuild,
  } = getTargetBranchPolicy({ base, head })

  // https://github.com/NixOS/nixpkgs/pull/521157
  // These should go to master and release-xx.xx when backported
  const isExemptKernelUpdate =
    onlyChangedFile === 'pkgs/os-specific/linux/kernel/xanmod-kernels.nix'

  // https://github.com/NixOS/nixpkgs/pull/483194#issuecomment-3793393218
  const isExemptHomeAssistantUpdate =
    maxRebuildCount <= 1500 && head === 'wip-home-assistant'

  const details = {
    isExemptKernelUpdate,
    isExemptHomeAssistantUpdate,
  }

  const result = (decision: TargetBranchReviewDecision) => ({
    decision,
    details,
  })

  const isMassRebuild =
    maxRebuildCount >= 1000 &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate

  if (shouldCheckMassRebuild && isMassRebuild) {
    return result('mass-rebuild')
  }

  if (shouldCheckNixosRebuild && rebuildsAllTests && !isExemptKernelUpdate) {
    return result('nixos-rebuild')
  }

  const isPossibleMassRebuild =
    maxRebuildCount >= 500 &&
    !isMassRebuild &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate
  if (
    shouldCheckMassRebuild &&
    isPossibleMassRebuild &&
    !(rebuildsAllTests && isStagingNixosBase)
  ) {
    return result('possible-mass-rebuild')
  }

  return result(
    shouldSkipDevelopmentMerge ? 'skip-development-merge' : 'dismiss',
  )
}
