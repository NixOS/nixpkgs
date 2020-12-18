/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "Config.h"
#include "PartitionJob.h"
#include "UsersJob.h"

#include "ViewManager.h"

#include <QVariant>

Config::Config( QObject* parent )
    : QObject( parent )
{
}

QString
cfgStr( const QVariantMap& cfgMap, QString key, QString defaultStr )
{
    QString ret = cfgMap.value( key ).toString();
    if ( ret.isEmpty() )
    {
        return defaultStr;
    }
    return ret;
}

bool
cfgBool( const QVariantMap& cfgMap, QString key, bool defaultBool )
{
    if ( cfgMap.contains( key ) )
    {
        return cfgMap.value( key ).toBool();
    }
    return defaultBool;
}

void
Config::setConfigurationMap( const QVariantMap& cfgMap )
{
    m_osName = cfgStr( cfgMap, "osName", "(unknown)" );
    m_arch = cfgStr( cfgMap, "arch", "(unknown)" );
    m_device = cfgStr( cfgMap, "device", "(unknown)" );
    m_userInterface = cfgStr( cfgMap, "userInterface", "(unknown)" );
    m_version = cfgStr( cfgMap, "version", "(unknown)" );
    m_username = cfgStr( cfgMap, "username", "user" );

    m_featureSshd = cfgBool( cfgMap, "featureSshd", true );

    m_cmdLuksFormat = cfgStr( cfgMap, "cmdLuksFormat", "cryptsetup luksFormat --use-random" );
    m_cmdLuksOpen = cfgStr( cfgMap, "cmdLuksOpen", "cryptsetup luksOpen" );
    m_cmdMkfsRoot = cfgStr( cfgMap, "cmdMkfsRoot", "mkfs.ext4 -L 'unknownOS_root'" );
    m_cmdMount = cfgStr( cfgMap, "cmdMount", "mount" );
    m_targetDeviceRoot = cfgStr( cfgMap, "targetDeviceRoot", "/dev/unknown" );

    m_cmdPasswd = cfgStr( cfgMap, "cmdPasswd", "passwd" );
    m_cmdSshdEnable = cfgStr( cfgMap, "cmdSshdEnable", "systemctl enable sshd.service" );
    m_cmdSshdDisable = cfgStr( cfgMap, "cmdSshdDisable", "systemctl disable sshd.service" );
    m_cmdSshdUseradd = cfgStr( cfgMap, "cmdSshdUseradd", "useradd -G wheel -m" );
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
    /* HACK: run partition job
     * The "mobile" module has two jobs, the partition job and the users job.
     * If we added both of them in Config::createJobs(), Calamares would run
     * them right after each other. But we need the "unpackfs" module to run
     * inbetween, that's why as workaround, the partition job is started here.
     * To solve this properly, we would need to place the partition job in an
     * own module and pass everything via globalstorage. But then we might as
     * well refactor everything so we can unify the mobile's partition job with
     * the proper partition job from Calamares. */
    Calamares::Job* j = new PartitionJob(
        m_cmdLuksFormat, m_cmdLuksOpen, m_cmdMkfsRoot, m_cmdMount, m_targetDeviceRoot, m_isFdeEnabled, m_fdePassword );
    Calamares::JobResult res = j->exec();

    Calamares::ViewManager* v = Calamares::ViewManager::instance();
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
