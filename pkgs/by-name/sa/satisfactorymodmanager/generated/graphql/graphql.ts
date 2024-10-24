/* eslint-disable */
import type { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  AnnouncementID: { input: string; output: string; }
  Date: { input: any; output: any; }
  GuideID: { input: string; output: string; }
  ModID: { input: string; output: string; }
  ModReference: { input: string; output: string; }
  SMLVersionID: { input: any; output: any; }
  SatisfactoryVersionID: { input: any; output: any; }
  TagID: { input: string; output: string; }
  TagName: { input: any; output: any; }
  Upload: { input: any; output: any; }
  UserID: { input: string; output: string; }
  VersionID: { input: string; output: string; }
  VirustotalHash: { input: any; output: any; }
  VirustotalID: { input: any; output: any; }
};

export type Announcement = {
  __typename?: 'Announcement';
  id: Scalars['AnnouncementID']['output'];
  importance: AnnouncementImportance;
  message: Scalars['String']['output'];
};

export enum AnnouncementImportance {
  Alert = 'Alert',
  Fix = 'Fix',
  Info = 'Info',
  Warning = 'Warning'
}

export type Compatibility = {
  __typename?: 'Compatibility';
  note?: Maybe<Scalars['String']['output']>;
  state: CompatibilityState;
};

export type CompatibilityInfo = {
  __typename?: 'CompatibilityInfo';
  EA: Compatibility;
  EXP: Compatibility;
};

export type CompatibilityInfoInput = {
  EA: CompatibilityInput;
  EXP: CompatibilityInput;
};

export type CompatibilityInput = {
  note?: InputMaybe<Scalars['String']['input']>;
  state: CompatibilityState;
};

export enum CompatibilityState {
  Broken = 'Broken',
  Damaged = 'Damaged',
  Works = 'Works'
}

export type CreateVersionResponse = {
  __typename?: 'CreateVersionResponse';
  auto_approved: Scalars['Boolean']['output'];
  version?: Maybe<Version>;
};

export type GetGuides = {
  __typename?: 'GetGuides';
  count: Scalars['Int']['output'];
  guides: Array<Guide>;
};

export type GetMods = {
  __typename?: 'GetMods';
  count: Scalars['Int']['output'];
  mods: Array<Mod>;
};

export type GetMyMods = {
  __typename?: 'GetMyMods';
  count: Scalars['Int']['output'];
  mods: Array<Mod>;
};

export type GetMyVersions = {
  __typename?: 'GetMyVersions';
  count: Scalars['Int']['output'];
  versions: Array<Version>;
};

export type GetSmlVersions = {
  __typename?: 'GetSMLVersions';
  count: Scalars['Int']['output'];
  sml_versions: Array<SmlVersion>;
};

export type GetVersions = {
  __typename?: 'GetVersions';
  count: Scalars['Int']['output'];
  versions: Array<Version>;
};

export type Group = {
  __typename?: 'Group';
  id: Scalars['String']['output'];
  name: Scalars['String']['output'];
};

export type Guide = {
  __typename?: 'Guide';
  created_at: Scalars['Date']['output'];
  guide: Scalars['String']['output'];
  id: Scalars['GuideID']['output'];
  name: Scalars['String']['output'];
  short_description: Scalars['String']['output'];
  tags: Array<Tag>;
  updated_at: Scalars['Date']['output'];
  user: User;
  user_id: Scalars['UserID']['output'];
  views: Scalars['Int']['output'];
};

export enum GuideFields {
  CreatedAt = 'created_at',
  Name = 'name',
  UpdatedAt = 'updated_at',
  Views = 'views'
}

export type GuideFilter = {
  ids?: InputMaybe<Array<Scalars['String']['input']>>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Order>;
  order_by?: InputMaybe<GuideFields>;
  search?: InputMaybe<Scalars['String']['input']>;
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
};

export type LatestVersions = {
  __typename?: 'LatestVersions';
  alpha?: Maybe<Version>;
  beta?: Maybe<Version>;
  release?: Maybe<Version>;
};

export type Mod = {
  __typename?: 'Mod';
  approved: Scalars['Boolean']['output'];
  authors: Array<UserMod>;
  compatibility?: Maybe<CompatibilityInfo>;
  created_at: Scalars['Date']['output'];
  creator_id: Scalars['UserID']['output'];
  downloads: Scalars['Int']['output'];
  full_description?: Maybe<Scalars['String']['output']>;
  hidden: Scalars['Boolean']['output'];
  hotness: Scalars['Int']['output'];
  id: Scalars['ModID']['output'];
  last_version_date?: Maybe<Scalars['Date']['output']>;
  latestVersions: LatestVersions;
  logo?: Maybe<Scalars['String']['output']>;
  logo_thumbhash?: Maybe<Scalars['String']['output']>;
  mod_reference: Scalars['ModReference']['output'];
  name: Scalars['String']['output'];
  popularity: Scalars['Int']['output'];
  short_description: Scalars['String']['output'];
  source_url?: Maybe<Scalars['String']['output']>;
  tags?: Maybe<Array<Tag>>;
  toggle_explicit_content: Scalars['Boolean']['output'];
  toggle_network_use: Scalars['Boolean']['output'];
  updated_at: Scalars['Date']['output'];
  version?: Maybe<Version>;
  versions: Array<Version>;
  views: Scalars['Int']['output'];
};


export type ModVersionArgs = {
  version: Scalars['String']['input'];
};


export type ModVersionsArgs = {
  filter?: InputMaybe<VersionFilter>;
};

export enum ModFields {
  CreatedAt = 'created_at',
  Downloads = 'downloads',
  Hotness = 'hotness',
  LastVersionDate = 'last_version_date',
  Name = 'name',
  Popularity = 'popularity',
  Search = 'search',
  UpdatedAt = 'updated_at',
  Views = 'views'
}

export type ModFilter = {
  hidden?: InputMaybe<Scalars['Boolean']['input']>;
  ids?: InputMaybe<Array<Scalars['String']['input']>>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Order>;
  order_by?: InputMaybe<ModFields>;
  references?: InputMaybe<Array<Scalars['String']['input']>>;
  search?: InputMaybe<Scalars['String']['input']>;
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
};

export type ModVersion = {
  __typename?: 'ModVersion';
  id: Scalars['ModID']['output'];
  mod_reference: Scalars['ModReference']['output'];
  versions: Array<Version>;
};

export type ModVersionConstraint = {
  modIdOrReference: Scalars['String']['input'];
  version: Scalars['String']['input'];
};

export type Mutation = {
  __typename?: 'Mutation';
  approveMod: Scalars['Boolean']['output'];
  approveVersion: Scalars['Boolean']['output'];
  createAnnouncement?: Maybe<Announcement>;
  createGuide?: Maybe<Guide>;
  createMod?: Maybe<Mod>;
  createMultipleTags: Array<Tag>;
  createSatisfactoryVersion: SatisfactoryVersion;
  createTag?: Maybe<Tag>;
  createVersion: Scalars['VersionID']['output'];
  deleteAnnouncement: Scalars['Boolean']['output'];
  deleteGuide: Scalars['Boolean']['output'];
  deleteMod: Scalars['Boolean']['output'];
  deleteSatisfactoryVersion: Scalars['Boolean']['output'];
  deleteTag: Scalars['Boolean']['output'];
  deleteVersion: Scalars['Boolean']['output'];
  denyMod: Scalars['Boolean']['output'];
  denyVersion: Scalars['Boolean']['output'];
  discourseSSO?: Maybe<Scalars['String']['output']>;
  finalizeCreateVersion: Scalars['Boolean']['output'];
  logout: Scalars['Boolean']['output'];
  oAuthFacebook?: Maybe<UserSession>;
  oAuthGithub?: Maybe<UserSession>;
  oAuthGoogle?: Maybe<UserSession>;
  updateAnnouncement: Announcement;
  updateGuide: Guide;
  updateMod: Mod;
  updateModCompatibility: Scalars['Boolean']['output'];
  updateMultipleModCompatibilities: Scalars['Boolean']['output'];
  updateSatisfactoryVersion: SatisfactoryVersion;
  updateTag: Tag;
  updateUser: User;
  updateVersion: Version;
  uploadVersionPart: Scalars['Boolean']['output'];
};


export type MutationApproveModArgs = {
  modId: Scalars['ModID']['input'];
};


export type MutationApproveVersionArgs = {
  versionId: Scalars['VersionID']['input'];
};


export type MutationCreateAnnouncementArgs = {
  announcement: NewAnnouncement;
};


export type MutationCreateGuideArgs = {
  guide: NewGuide;
};


export type MutationCreateModArgs = {
  mod: NewMod;
};


export type MutationCreateMultipleTagsArgs = {
  tagNames: Array<NewTag>;
};


export type MutationCreateSatisfactoryVersionArgs = {
  input: NewSatisfactoryVersion;
};


export type MutationCreateTagArgs = {
  description: Scalars['String']['input'];
  tagName: Scalars['TagName']['input'];
};


export type MutationCreateVersionArgs = {
  modId: Scalars['ModID']['input'];
};


export type MutationDeleteAnnouncementArgs = {
  announcementId: Scalars['AnnouncementID']['input'];
};


export type MutationDeleteGuideArgs = {
  guideId: Scalars['GuideID']['input'];
};


export type MutationDeleteModArgs = {
  modId: Scalars['ModID']['input'];
};


export type MutationDeleteSatisfactoryVersionArgs = {
  id: Scalars['SatisfactoryVersionID']['input'];
};


export type MutationDeleteTagArgs = {
  tagID: Scalars['TagID']['input'];
};


export type MutationDeleteVersionArgs = {
  versionId: Scalars['VersionID']['input'];
};


export type MutationDenyModArgs = {
  modId: Scalars['ModID']['input'];
};


export type MutationDenyVersionArgs = {
  versionId: Scalars['VersionID']['input'];
};


export type MutationDiscourseSsoArgs = {
  sig: Scalars['String']['input'];
  sso: Scalars['String']['input'];
};


export type MutationFinalizeCreateVersionArgs = {
  modId: Scalars['ModID']['input'];
  version: NewVersion;
  versionId: Scalars['VersionID']['input'];
};


export type MutationOAuthFacebookArgs = {
  code: Scalars['String']['input'];
  state: Scalars['String']['input'];
};


export type MutationOAuthGithubArgs = {
  code: Scalars['String']['input'];
  state: Scalars['String']['input'];
};


export type MutationOAuthGoogleArgs = {
  code: Scalars['String']['input'];
  state: Scalars['String']['input'];
};


export type MutationUpdateAnnouncementArgs = {
  announcement: UpdateAnnouncement;
  announcementId: Scalars['AnnouncementID']['input'];
};


export type MutationUpdateGuideArgs = {
  guide: UpdateGuide;
  guideId: Scalars['GuideID']['input'];
};


export type MutationUpdateModArgs = {
  mod: UpdateMod;
  modId: Scalars['ModID']['input'];
};


export type MutationUpdateModCompatibilityArgs = {
  compatibility: CompatibilityInfoInput;
  modId: Scalars['ModID']['input'];
};


export type MutationUpdateMultipleModCompatibilitiesArgs = {
  compatibility: CompatibilityInfoInput;
  modIDs: Array<Scalars['ModID']['input']>;
};


export type MutationUpdateSatisfactoryVersionArgs = {
  id: Scalars['SatisfactoryVersionID']['input'];
  input: UpdateSatisfactoryVersion;
};


export type MutationUpdateTagArgs = {
  NewName: Scalars['TagName']['input'];
  description: Scalars['String']['input'];
  tagID: Scalars['TagID']['input'];
};


export type MutationUpdateUserArgs = {
  input: UpdateUser;
  userId: Scalars['UserID']['input'];
};


export type MutationUpdateVersionArgs = {
  version: UpdateVersion;
  versionId: Scalars['VersionID']['input'];
};


export type MutationUploadVersionPartArgs = {
  file: Scalars['Upload']['input'];
  modId: Scalars['ModID']['input'];
  part: Scalars['Int']['input'];
  versionId: Scalars['VersionID']['input'];
};

export type NewAnnouncement = {
  importance: AnnouncementImportance;
  message: Scalars['String']['input'];
};

export type NewGuide = {
  guide: Scalars['String']['input'];
  name: Scalars['String']['input'];
  short_description: Scalars['String']['input'];
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
};

export type NewMod = {
  full_description?: InputMaybe<Scalars['String']['input']>;
  hidden?: InputMaybe<Scalars['Boolean']['input']>;
  logo?: InputMaybe<Scalars['Upload']['input']>;
  mod_reference: Scalars['ModReference']['input'];
  name: Scalars['String']['input'];
  short_description: Scalars['String']['input'];
  source_url?: InputMaybe<Scalars['String']['input']>;
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
  toggle_explicit_content?: InputMaybe<Scalars['Boolean']['input']>;
  toggle_network_use?: InputMaybe<Scalars['Boolean']['input']>;
};

export type NewSatisfactoryVersion = {
  engine_version: Scalars['String']['input'];
  version: Scalars['Int']['input'];
};

export type NewTag = {
  description: Scalars['String']['input'];
  name: Scalars['TagName']['input'];
};

export type NewVersion = {
  changelog: Scalars['String']['input'];
  stability: VersionStabilities;
};

export type OAuthOptions = {
  __typename?: 'OAuthOptions';
  facebook: Scalars['String']['output'];
  github: Scalars['String']['output'];
  google: Scalars['String']['output'];
};

export enum Order {
  Asc = 'asc',
  Desc = 'desc'
}

export type Query = {
  __typename?: 'Query';
  checkVersionUploadState?: Maybe<CreateVersionResponse>;
  getAnnouncement?: Maybe<Announcement>;
  getAnnouncements: Array<Announcement>;
  getAnnouncementsByImportance: Array<Announcement>;
  getGuide?: Maybe<Guide>;
  getGuides: GetGuides;
  getMe?: Maybe<User>;
  getMod?: Maybe<Mod>;
  getModAssetList: Array<Scalars['String']['output']>;
  getModByIdOrReference?: Maybe<Mod>;
  getModByReference?: Maybe<Mod>;
  getMods: GetMods;
  getMyMods: GetMyMods;
  getMyUnapprovedMods: GetMyMods;
  getMyUnapprovedVersions: GetMyVersions;
  getMyVersions: GetMyVersions;
  getOAuthOptions: OAuthOptions;
  /** @deprecated SML is now a mod */
  getSMLVersion?: Maybe<SmlVersion>;
  /** @deprecated SML is now a mod */
  getSMLVersions: GetSmlVersions;
  getSatisfactoryVersion?: Maybe<SatisfactoryVersion>;
  getSatisfactoryVersions: Array<SatisfactoryVersion>;
  getTag?: Maybe<Tag>;
  getTags: Array<Tag>;
  getUnapprovedMods: GetMods;
  getUnapprovedVersions: GetVersions;
  getUser?: Maybe<User>;
  getUsers: Array<Maybe<User>>;
  getVersion?: Maybe<Version>;
  getVersions: GetVersions;
  resolveModVersions: Array<ModVersion>;
};


export type QueryCheckVersionUploadStateArgs = {
  modId: Scalars['ModID']['input'];
  versionId: Scalars['VersionID']['input'];
};


export type QueryGetAnnouncementArgs = {
  announcementId: Scalars['AnnouncementID']['input'];
};


export type QueryGetAnnouncementsByImportanceArgs = {
  importance: AnnouncementImportance;
};


export type QueryGetGuideArgs = {
  guideId: Scalars['GuideID']['input'];
};


export type QueryGetGuidesArgs = {
  filter?: InputMaybe<GuideFilter>;
};


export type QueryGetModArgs = {
  modId: Scalars['ModID']['input'];
};


export type QueryGetModAssetListArgs = {
  modReference: Scalars['ModID']['input'];
};


export type QueryGetModByIdOrReferenceArgs = {
  modIdOrReference: Scalars['String']['input'];
};


export type QueryGetModByReferenceArgs = {
  modReference: Scalars['ModReference']['input'];
};


export type QueryGetModsArgs = {
  filter?: InputMaybe<ModFilter>;
};


export type QueryGetMyModsArgs = {
  filter?: InputMaybe<ModFilter>;
};


export type QueryGetMyUnapprovedModsArgs = {
  filter?: InputMaybe<ModFilter>;
};


export type QueryGetMyUnapprovedVersionsArgs = {
  filter?: InputMaybe<VersionFilter>;
};


export type QueryGetMyVersionsArgs = {
  filter?: InputMaybe<VersionFilter>;
};


export type QueryGetOAuthOptionsArgs = {
  callback_url: Scalars['String']['input'];
};


export type QueryGetSmlVersionArgs = {
  smlVersionID: Scalars['SMLVersionID']['input'];
};


export type QueryGetSmlVersionsArgs = {
  filter?: InputMaybe<SmlVersionFilter>;
};


export type QueryGetSatisfactoryVersionArgs = {
  id: Scalars['SatisfactoryVersionID']['input'];
};


export type QueryGetTagArgs = {
  tagID: Scalars['TagID']['input'];
};


export type QueryGetTagsArgs = {
  filter?: InputMaybe<TagFilter>;
};


export type QueryGetUnapprovedModsArgs = {
  filter?: InputMaybe<ModFilter>;
};


export type QueryGetUnapprovedVersionsArgs = {
  filter?: InputMaybe<VersionFilter>;
};


export type QueryGetUserArgs = {
  userId: Scalars['UserID']['input'];
};


export type QueryGetUsersArgs = {
  userIds: Array<Scalars['UserID']['input']>;
};


export type QueryGetVersionArgs = {
  versionId: Scalars['VersionID']['input'];
};


export type QueryGetVersionsArgs = {
  filter?: InputMaybe<VersionFilter>;
};


export type QueryResolveModVersionsArgs = {
  filter: Array<ModVersionConstraint>;
};

export type SmlVersion = {
  __typename?: 'SMLVersion';
  bootstrap_version?: Maybe<Scalars['String']['output']>;
  changelog: Scalars['String']['output'];
  created_at: Scalars['Date']['output'];
  date: Scalars['Date']['output'];
  engine_version: Scalars['String']['output'];
  id: Scalars['SMLVersionID']['output'];
  link: Scalars['String']['output'];
  satisfactory_version: Scalars['Int']['output'];
  stability: VersionStabilities;
  targets: Array<Maybe<SmlVersionTarget>>;
  updated_at: Scalars['Date']['output'];
  version: Scalars['String']['output'];
};

export enum SmlVersionFields {
  CreatedAt = 'created_at',
  Date = 'date',
  Name = 'name',
  SatisfactoryVersion = 'satisfactory_version',
  UpdatedAt = 'updated_at'
}

export type SmlVersionFilter = {
  ids?: InputMaybe<Array<Scalars['String']['input']>>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Order>;
  order_by?: InputMaybe<SmlVersionFields>;
  search?: InputMaybe<Scalars['String']['input']>;
};

export type SmlVersionTarget = {
  __typename?: 'SMLVersionTarget';
  VersionID: Scalars['SMLVersionID']['output'];
  link: Scalars['String']['output'];
  targetName: TargetName;
};

export type SatisfactoryVersion = {
  __typename?: 'SatisfactoryVersion';
  engine_version: Scalars['String']['output'];
  id: Scalars['SatisfactoryVersionID']['output'];
  version: Scalars['Int']['output'];
};

export type Tag = {
  __typename?: 'Tag';
  description: Scalars['String']['output'];
  id: Scalars['TagID']['output'];
  name: Scalars['TagName']['output'];
};

export type TagFilter = {
  ids?: InputMaybe<Array<Scalars['TagID']['input']>>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Order>;
  search?: InputMaybe<Scalars['String']['input']>;
};

export enum TargetName {
  LinuxServer = 'LinuxServer',
  Windows = 'Windows',
  WindowsServer = 'WindowsServer'
}

export type UpdateAnnouncement = {
  importance?: InputMaybe<AnnouncementImportance>;
  message?: InputMaybe<Scalars['String']['input']>;
};

export type UpdateGuide = {
  guide?: InputMaybe<Scalars['String']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
  short_description?: InputMaybe<Scalars['String']['input']>;
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
};

export type UpdateMod = {
  authors?: InputMaybe<Array<UpdateUserMod>>;
  compatibility?: InputMaybe<CompatibilityInfoInput>;
  full_description?: InputMaybe<Scalars['String']['input']>;
  hidden?: InputMaybe<Scalars['Boolean']['input']>;
  logo?: InputMaybe<Scalars['Upload']['input']>;
  mod_reference?: InputMaybe<Scalars['ModReference']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
  short_description?: InputMaybe<Scalars['String']['input']>;
  source_url?: InputMaybe<Scalars['String']['input']>;
  tagIDs?: InputMaybe<Array<Scalars['TagID']['input']>>;
  toggle_explicit_content?: InputMaybe<Scalars['Boolean']['input']>;
  toggle_network_use?: InputMaybe<Scalars['Boolean']['input']>;
};

export type UpdateSatisfactoryVersion = {
  engine_version?: InputMaybe<Scalars['String']['input']>;
  version?: InputMaybe<Scalars['Int']['input']>;
};

export type UpdateUser = {
  avatar?: InputMaybe<Scalars['Upload']['input']>;
  groups?: InputMaybe<Array<Scalars['String']['input']>>;
  username?: InputMaybe<Scalars['String']['input']>;
};

export type UpdateUserMod = {
  role: Scalars['String']['input'];
  user_id: Scalars['UserID']['input'];
};

export type UpdateVersion = {
  changelog?: InputMaybe<Scalars['String']['input']>;
  stability?: InputMaybe<VersionStabilities>;
};

export type User = {
  __typename?: 'User';
  avatar?: Maybe<Scalars['String']['output']>;
  avatar_thumbhash?: Maybe<Scalars['String']['output']>;
  created_at: Scalars['Date']['output'];
  email?: Maybe<Scalars['String']['output']>;
  facebook_id?: Maybe<Scalars['String']['output']>;
  github_id?: Maybe<Scalars['String']['output']>;
  google_id?: Maybe<Scalars['String']['output']>;
  groups: Array<Group>;
  guides: Array<Guide>;
  id: Scalars['UserID']['output'];
  mods: Array<UserMod>;
  roles: UserRoles;
  username: Scalars['String']['output'];
};

export type UserMod = {
  __typename?: 'UserMod';
  mod: Mod;
  mod_id: Scalars['ModID']['output'];
  role: Scalars['String']['output'];
  user: User;
  user_id: Scalars['UserID']['output'];
};

export type UserRoles = {
  __typename?: 'UserRoles';
  approveMods: Scalars['Boolean']['output'];
  approveVersions: Scalars['Boolean']['output'];
  deleteContent: Scalars['Boolean']['output'];
  editAnyModCompatibility: Scalars['Boolean']['output'];
  editBootstrapVersions: Scalars['Boolean']['output'];
  editContent: Scalars['Boolean']['output'];
  editSatisfactoryVersions: Scalars['Boolean']['output'];
  editUsers: Scalars['Boolean']['output'];
};

export type UserSession = {
  __typename?: 'UserSession';
  token: Scalars['String']['output'];
};

export type Version = {
  __typename?: 'Version';
  approved: Scalars['Boolean']['output'];
  changelog: Scalars['String']['output'];
  created_at: Scalars['Date']['output'];
  dependencies: Array<VersionDependency>;
  downloads: Scalars['Int']['output'];
  game_version: Scalars['String']['output'];
  hash?: Maybe<Scalars['String']['output']>;
  id: Scalars['VersionID']['output'];
  link: Scalars['String']['output'];
  metadata?: Maybe<Scalars['String']['output']>;
  mod: Mod;
  mod_id: Scalars['ModID']['output'];
  required_on_remote: Scalars['Boolean']['output'];
  size?: Maybe<Scalars['Int']['output']>;
  sml_version: Scalars['String']['output'];
  stability: VersionStabilities;
  targets: Array<Maybe<VersionTarget>>;
  updated_at: Scalars['Date']['output'];
  version: Scalars['String']['output'];
  virustotal_results: Array<VirustotalResult>;
};

export type VersionDependency = {
  __typename?: 'VersionDependency';
  condition: Scalars['String']['output'];
  mod?: Maybe<Mod>;
  /** @deprecated soon will return actual mod id instead of reference. use mod_reference field instead! */
  mod_id: Scalars['ModID']['output'];
  mod_reference: Scalars['String']['output'];
  optional: Scalars['Boolean']['output'];
  version?: Maybe<Version>;
  version_id: Scalars['VersionID']['output'];
};

export enum VersionFields {
  CreatedAt = 'created_at',
  Downloads = 'downloads',
  UpdatedAt = 'updated_at'
}

export type VersionFilter = {
  ids?: InputMaybe<Array<Scalars['String']['input']>>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Order>;
  order_by?: InputMaybe<VersionFields>;
  search?: InputMaybe<Scalars['String']['input']>;
};

export enum VersionStabilities {
  Alpha = 'alpha',
  Beta = 'beta',
  Release = 'release'
}

export type VersionTarget = {
  __typename?: 'VersionTarget';
  VersionID: Scalars['VersionID']['output'];
  hash?: Maybe<Scalars['String']['output']>;
  link: Scalars['String']['output'];
  size?: Maybe<Scalars['Int']['output']>;
  targetName: TargetName;
};

export type VirustotalResult = {
  __typename?: 'VirustotalResult';
  created_at: Scalars['Date']['output'];
  file_name: Scalars['String']['output'];
  hash: Scalars['VirustotalHash']['output'];
  id?: Maybe<Scalars['VirustotalID']['output']>;
  safe: Scalars['Boolean']['output'];
  updated_at?: Maybe<Scalars['Date']['output']>;
  version_id: Scalars['String']['output'];
};

export type GetAnnouncementsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetAnnouncementsQuery = { __typename?: 'Query', getAnnouncements: Array<{ __typename?: 'Announcement', id: string, message: string, importance: AnnouncementImportance }> };

export type SmrHealthcheckQueryVariables = Exact<{ [key: string]: never; }>;


export type SmrHealthcheckQuery = { __typename?: 'Query', getMods: { __typename?: 'GetMods', count: number } };

export type GetModCountQueryVariables = Exact<{ [key: string]: never; }>;


export type GetModCountQuery = { __typename?: 'Query', getMods: { __typename?: 'GetMods', count: number } };

export type GetModDetailsQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type GetModDetailsQuery = { __typename?: 'Query', mod?: { __typename?: 'Mod', name: string, logo?: string | null, logo_thumbhash?: string | null, mod_reference: string, full_description?: string | null, created_at: any, last_version_date?: any | null, downloads: number, views: number, hidden: boolean, id: string, compatibility?: { __typename?: 'CompatibilityInfo', EA: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null }, EXP: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null } } | null, authors: Array<{ __typename?: 'UserMod', role: string, user: { __typename?: 'User', id: string, username: string, avatar?: string | null } }>, versions: Array<{ __typename?: 'Version', id: string, version: string, size?: number | null, changelog: string }> } | null };

export type ModKeyFragment = { __typename?: 'Mod', id: string, mod_reference: string };

export type GetModNameQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type GetModNameQuery = { __typename?: 'Query', getModByReference?: { __typename?: 'Mod', name: string, id: string, mod_reference: string } | null };

export type GetModNamesQueryVariables = Exact<{
  modReferences: Array<Scalars['String']['input']> | Scalars['String']['input'];
}>;


export type GetModNamesQuery = { __typename?: 'Query', getMods: { __typename?: 'GetMods', mods: Array<{ __typename?: 'Mod', name: string, id: string, mod_reference: string }> } };

export type GetModReferenceQueryVariables = Exact<{
  modIdOrReference: Scalars['String']['input'];
}>;


export type GetModReferenceQuery = { __typename?: 'Query', getModByIdOrReference?: { __typename?: 'Mod', mod_reference: string, id: string } | null };

export type GetModSummaryQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type GetModSummaryQuery = { __typename?: 'Query', mod?: { __typename?: 'Mod', name: string, logo?: string | null, mod_reference: string, created_at: any, downloads: number, views: number, short_description: string, id: string } | null };

export type GetModVersionTargetsQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type GetModVersionTargetsQuery = { __typename?: 'Query', mod?: { __typename?: 'Mod', id: string, mod_reference: string, versions: Array<{ __typename?: 'Version', id: string, version: string, required_on_remote: boolean, targets: Array<{ __typename?: 'VersionTarget', targetName: TargetName } | null> }> } | null };

export type GetModsQueryVariables = Exact<{
  offset: Scalars['Int']['input'];
  limit: Scalars['Int']['input'];
}>;


export type GetModsQuery = { __typename?: 'Query', getMods: { __typename?: 'GetMods', count: number, mods: Array<{ __typename?: 'Mod', mod_reference: string, name: string, logo?: string | null, logo_thumbhash?: string | null, short_description: string, hidden: boolean, popularity: number, hotness: number, views: number, downloads: number, last_version_date?: any | null, id: string, tags?: Array<{ __typename?: 'Tag', id: string, name: any }> | null, authors: Array<{ __typename?: 'UserMod', role: string, user: { __typename?: 'User', id: string, username: string } }>, compatibility?: { __typename?: 'CompatibilityInfo', EA: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null }, EXP: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null } } | null, versions: Array<{ __typename?: 'Version', id: string, version: string, dependencies: Array<{ __typename?: 'VersionDependency', mod_reference: string, condition: string }>, targets: Array<{ __typename?: 'VersionTarget', targetName: TargetName } | null> }> }> } };

export type GetChangelogQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type GetChangelogQuery = { __typename?: 'Query', getModByReference?: { __typename?: 'Mod', name: string, id: string, mod_reference: string, versions: Array<{ __typename?: 'Version', id: string, version: string, changelog: string }> } | null };

export type ModReportedCompatibilityQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type ModReportedCompatibilityQuery = { __typename?: 'Query', getModByReference?: { __typename?: 'Mod', id: string, mod_reference: string, compatibility?: { __typename?: 'CompatibilityInfo', EA: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null }, EXP: { __typename?: 'Compatibility', state: CompatibilityState, note?: string | null } } | null } | null };

export type ModVersionsCompatibilityQueryVariables = Exact<{
  modReference: Scalars['ModReference']['input'];
}>;


export type ModVersionsCompatibilityQuery = { __typename?: 'Query', getModByReference?: { __typename?: 'Mod', id: string, mod_reference: string, versions: Array<{ __typename?: 'Version', id: string, version: string, game_version: string, required_on_remote: boolean, dependencies: Array<{ __typename?: 'VersionDependency', mod_reference: string, condition: string }> }> } | null };

export const ModKeyFragmentDoc = {"kind":"Document","definitions":[{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<ModKeyFragment, unknown>;
export const GetAnnouncementsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetAnnouncements"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getAnnouncements"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"message"}},{"kind":"Field","name":{"kind":"Name","value":"importance"}}]}}]}}]} as unknown as DocumentNode<GetAnnouncementsQuery, GetAnnouncementsQueryVariables>;
export const SmrHealthcheckDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"SMRHealthcheck"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getMods"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"count"}}]}}]}}]} as unknown as DocumentNode<SmrHealthcheckQuery, SmrHealthcheckQueryVariables>;
export const GetModCountDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModCount"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getMods"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"count"}}]}}]}}]} as unknown as DocumentNode<GetModCountQuery, GetModCountQueryVariables>;
export const GetModDetailsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModDetails"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","alias":{"kind":"Name","value":"mod"},"name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"logo"}},{"kind":"Field","name":{"kind":"Name","value":"logo_thumbhash"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}},{"kind":"Field","name":{"kind":"Name","value":"full_description"}},{"kind":"Field","name":{"kind":"Name","value":"created_at"}},{"kind":"Field","name":{"kind":"Name","value":"last_version_date"}},{"kind":"Field","name":{"kind":"Name","value":"downloads"}},{"kind":"Field","name":{"kind":"Name","value":"views"}},{"kind":"Field","name":{"kind":"Name","value":"hidden"}},{"kind":"Field","name":{"kind":"Name","value":"compatibility"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"EA"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}},{"kind":"Field","name":{"kind":"Name","value":"EXP"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}}]}},{"kind":"Field","name":{"kind":"Name","value":"authors"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"user"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"username"}},{"kind":"Field","name":{"kind":"Name","value":"avatar"}}]}},{"kind":"Field","name":{"kind":"Name","value":"role"}}]}},{"kind":"Field","name":{"kind":"Name","value":"versions"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"filter"},"value":{"kind":"ObjectValue","fields":[{"kind":"ObjectField","name":{"kind":"Name","value":"limit"},"value":{"kind":"IntValue","value":"100"}}]}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"version"}},{"kind":"Field","name":{"kind":"Name","value":"size"}},{"kind":"Field","name":{"kind":"Name","value":"changelog"}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModDetailsQuery, GetModDetailsQueryVariables>;
export const GetModNameDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModName"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModNameQuery, GetModNameQueryVariables>;
export const GetModNamesDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModNames"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReferences"}},"type":{"kind":"NonNullType","type":{"kind":"ListType","type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getMods"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"filter"},"value":{"kind":"ObjectValue","fields":[{"kind":"ObjectField","name":{"kind":"Name","value":"references"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReferences"}}}]}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"mods"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModNamesQuery, GetModNamesQueryVariables>;
export const GetModReferenceDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModReference"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modIdOrReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getModByIdOrReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modIdOrReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modIdOrReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModReferenceQuery, GetModReferenceQueryVariables>;
export const GetModSummaryDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModSummary"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","alias":{"kind":"Name","value":"mod"},"name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"logo"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}},{"kind":"Field","name":{"kind":"Name","value":"created_at"}},{"kind":"Field","name":{"kind":"Name","value":"downloads"}},{"kind":"Field","name":{"kind":"Name","value":"views"}},{"kind":"Field","name":{"kind":"Name","value":"short_description"}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModSummaryQuery, GetModSummaryQueryVariables>;
export const GetModVersionTargetsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetModVersionTargets"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","alias":{"kind":"Name","value":"mod"},"name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"versions"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"version"}},{"kind":"Field","name":{"kind":"Name","value":"required_on_remote"}},{"kind":"Field","name":{"kind":"Name","value":"targets"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"targetName"}}]}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModVersionTargetsQuery, GetModVersionTargetsQueryVariables>;
export const GetModsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetMods"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"offset"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"Int"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"limit"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"Int"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getMods"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"filter"},"value":{"kind":"ObjectValue","fields":[{"kind":"ObjectField","name":{"kind":"Name","value":"limit"},"value":{"kind":"Variable","name":{"kind":"Name","value":"limit"}}},{"kind":"ObjectField","name":{"kind":"Name","value":"offset"},"value":{"kind":"Variable","name":{"kind":"Name","value":"offset"}}}]}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"count"}},{"kind":"Field","name":{"kind":"Name","value":"mods"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"logo"}},{"kind":"Field","name":{"kind":"Name","value":"logo_thumbhash"}},{"kind":"Field","name":{"kind":"Name","value":"short_description"}},{"kind":"Field","name":{"kind":"Name","value":"hidden"}},{"kind":"Field","name":{"kind":"Name","value":"popularity"}},{"kind":"Field","name":{"kind":"Name","value":"hotness"}},{"kind":"Field","name":{"kind":"Name","value":"views"}},{"kind":"Field","name":{"kind":"Name","value":"downloads"}},{"kind":"Field","name":{"kind":"Name","value":"last_version_date"}},{"kind":"Field","name":{"kind":"Name","value":"tags"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}},{"kind":"Field","name":{"kind":"Name","value":"authors"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"user"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"username"}}]}},{"kind":"Field","name":{"kind":"Name","value":"role"}}]}},{"kind":"Field","name":{"kind":"Name","value":"compatibility"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"EA"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}},{"kind":"Field","name":{"kind":"Name","value":"EXP"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}}]}},{"kind":"Field","name":{"kind":"Name","value":"versions"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"version"}},{"kind":"Field","name":{"kind":"Name","value":"dependencies"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}},{"kind":"Field","name":{"kind":"Name","value":"condition"}}]}},{"kind":"Field","name":{"kind":"Name","value":"targets"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"targetName"}}]}}]}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetModsQuery, GetModsQueryVariables>;
export const GetChangelogDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetChangelog"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"versions"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"filter"},"value":{"kind":"ObjectValue","fields":[{"kind":"ObjectField","name":{"kind":"Name","value":"limit"},"value":{"kind":"IntValue","value":"100"}}]}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"version"}},{"kind":"Field","name":{"kind":"Name","value":"changelog"}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<GetChangelogQuery, GetChangelogQueryVariables>;
export const ModReportedCompatibilityDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"ModReportedCompatibility"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"compatibility"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"EA"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}},{"kind":"Field","name":{"kind":"Name","value":"EXP"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"state"}},{"kind":"Field","name":{"kind":"Name","value":"note"}}]}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<ModReportedCompatibilityQuery, ModReportedCompatibilityQueryVariables>;
export const ModVersionsCompatibilityDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"ModVersionsCompatibility"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ModReference"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getModByReference"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"modReference"},"value":{"kind":"Variable","name":{"kind":"Name","value":"modReference"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"ModKey"}},{"kind":"Field","name":{"kind":"Name","value":"versions"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"version"}},{"kind":"Field","name":{"kind":"Name","value":"game_version"}},{"kind":"Field","name":{"kind":"Name","value":"required_on_remote"}},{"kind":"Field","name":{"kind":"Name","value":"dependencies"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}},{"kind":"Field","name":{"kind":"Name","value":"condition"}}]}}]}}]}}]}},{"kind":"FragmentDefinition","name":{"kind":"Name","value":"ModKey"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Mod"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"mod_reference"}}]}}]} as unknown as DocumentNode<ModVersionsCompatibilityQuery, ModVersionsCompatibilityQueryVariables>;