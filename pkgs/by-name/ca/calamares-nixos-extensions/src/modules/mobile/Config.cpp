/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "Config.h"
#include "PartitionJob.h"
#include "UsersJob.h"

#include "ViewManager.h"
#include "utils/Variant.h"

#include <QVariant>

Config::Config( QObject* parent )
    : QObject( parent )
{
}

void
Config::setConfigurationMap( const QVariantMap& cfgMap )
{
    using namespace CalamaresUtils;

    m_osName = getString( cfgMap, "osName", "(unknown)" );
    m_arch = getString( cfgMap, "arch", "(unknown)" );
    m_device = getString( cfgMap, "device", "(unknown)" );
    m_userInterface = getString( cfgMap, "userInterface", "(unknown)" );
    m_version = getString( cfgMap, "version", "(unknown)" );
    m_username = getString( cfgMap, "username", "user" );

    m_featureSshd = getBool( cfgMap, "featureSshd", true );
    m_featureFsType = getBool( cfgMap, "featureFsType", false );

    m_cmdLuksFormat = getString( cfgMap, "cmdLuksFormat", "cryptsetup luksFormat --use-random" );
    m_cmdLuksOpen = getString( cfgMap, "cmdLuksOpen", "cryptsetup luksOpen" );
    m_cmdMount = getString( cfgMap, "cmdMount", "mount" );
    m_targetDeviceRoot = getString( cfgMap, "targetDeviceRoot", "/dev/unknown" );
    m_targetDeviceRootInternal = getString( cfgMap, "targetDeviceRootInternal", "" );

    m_cmdMkfsRootBtrfs = getString( cfgMap, "cmdMkfsRootBtrfs", "mkfs.btrfs -L 'unknownOS_root'" );
    m_cmdMkfsRootExt4 = getString( cfgMap, "cmdMkfsRootExt4", "mkfs.ext4 -L 'unknownOS_root'" );
    m_cmdMkfsRootF2fs = getString( cfgMap, "cmdMkfsRootF2fs", "mkfs.f2fs -l 'unknownOS_root'" );
    m_fsList = getStringList( cfgMap, "fsModel", QStringList { "ext4", "f2fs", "btrfs" } );
    m_defaultFs = getString( cfgMap, "defaultFs", "ext4" );
    m_fsIndex = m_fsList.indexOf( m_defaultFs );
    m_fsType = m_defaultFs;

    m_cmdInternalStoragePrepare = getString( cfgMap, "cmdInternalStoragePrepare", "ondev-internal-storage-prepare" );
    m_cmdPasswd = getString( cfgMap, "cmdPasswd", "passwd" );
    m_cmdSshdEnable = getString( cfgMap, "cmdSshdEnable", "systemctl enable sshd.service" );
    m_cmdSshdDisable = getString( cfgMap, "cmdSshdDisable", "systemctl disable sshd.service" );
    m_cmdSshdUseradd = getString( cfgMap, "cmdSshdUseradd", "useradd -G wheel -m" );
}

Calamares::JobList
Config::createJobs()
{
    QList< Calamares::job_ptr > list;
    QString cmdSshd = m_isSshEnabled ? m_cmdSshdEnable : m_cmdSshdDisable;

    /* Put users job in queue (should run after unpackfs) */
    Calamares::Job* j = new UsersJob( m_featureSshd,
                                      m_cmdPasswd,
                                      cmdSshd,
                                      m_cmdSshdUseradd,
                                      m_isSshEnabled,
                                      m_username,
                                      m_userPassword,
                                      m_sshdUsername,
                                      m_sshdPassword );
    list.append( Calamares::job_ptr( j ) );

    return list;
}

void
Config::runPartitionJobThenLeave( bool b )
{
    Calamares::ViewManager* v = Calamares::ViewManager::instance();
    QString cmdMkfsRoot;
    if ( m_fsType == QStringLiteral( "btrfs" ) )
    {
        cmdMkfsRoot = m_cmdMkfsRootBtrfs;
    }
    else if ( m_fsType == QStringLiteral( "f2fs" ) )
    {
        cmdMkfsRoot = m_cmdMkfsRootF2fs;
    }
    else if ( m_fsType == QStringLiteral( "ext4" ) )
    {
        cmdMkfsRoot = m_cmdMkfsRootExt4;
    }
    else
    {
        v->onInstallationFailed( "Unknown filesystem: '" + m_fsType + "'", "");
    }
    /* HACK: run partition job
     * The "mobile" module has two jobs, the partition job and the users job.
     * If we added both of them in Config::createJobs(), Calamares would run
     * them right after each other. But we need the "unpackfs" module to run
     * inbetween, that's why as workaround, the partition job is started here.
     * To solve this properly, we would need to place the partition job in an
     * own module and pass everything via globalstorage. But then we might as
     * well refactor everything so we can unify the mobile's partition job with
     * the proper partition job from Calamares. */
    Calamares::Job* j = new PartitionJob( m_cmdInternalStoragePrepare,
                                          m_cmdLuksFormat,
                                          m_cmdLuksOpen,
                                          cmdMkfsRoot,
                                          m_cmdMount,
                                          m_targetDeviceRoot,
                                          m_targetDeviceRootInternal,
                                          m_installFromExternalToInternal,
                                          m_isFdeEnabled,
                                          m_fdePassword );
    Calamares::JobResult res = j->exec();

    if ( res )
    {
        v->next();
    }
    else
    {
        v->onInstallationFailed( res.message(), res.details() );
    }
}

void
Config::setUserPassword( const QString& userPassword )
{
    m_userPassword = userPassword;
    emit userPasswordChanged( m_userPassword );
}

void
Config::setSshdUsername( const QString& sshdUsername )
{
    m_sshdUsername = sshdUsername;
    emit sshdUsernameChanged( m_sshdUsername );
}

void
Config::setSshdPassword( const QString& sshdPassword )
{
    m_sshdPassword = sshdPassword;
    emit sshdPasswordChanged( m_sshdPassword );
}

void
Config::setIsSshEnabled( const bool isSshEnabled )
{
    m_isSshEnabled = isSshEnabled;
}

void
Config::setFdePassword( const QString& fdePassword )
{
    m_fdePassword = fdePassword;
    emit fdePasswordChanged( m_fdePassword );
}

void
Config::setIsFdeEnabled( const bool isFdeEnabled )
{
    m_isFdeEnabled = isFdeEnabled;
}

void
Config::setInstallFromExternalToInternal( const bool val )
{
    m_installFromExternalToInternal = val;
}

void
Config::setFsType( int idx )
{
    if ( idx >= 0 && idx < m_fsList.length() ) {
        setFsType( m_fsList[ idx ] );
    }
}
void
Config::setFsType( const QString& fsType )
{
    if ( fsType != m_fsType ) {
        m_fsType = fsType;
        emit fsTypeChanged( m_fsType );
    }
}

void
Config::setFsIndex( const int fsIndex )
{
    m_fsIndex = fsIndex;
    emit fsIndexChanged( m_fsIndex );
}
