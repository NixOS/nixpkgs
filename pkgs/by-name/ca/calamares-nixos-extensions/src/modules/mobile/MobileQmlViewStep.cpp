/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "MobileQmlViewStep.h"

#include "GlobalStorage.h"

#include "locale/LabelModel.h"
#include "utils/Dirs.h"
#include "utils/Logger.h"
#include "utils/Variant.h"

#include "Branding.h"
#include "modulesystem/ModuleManager.h"

#include <QProcess>

CALAMARES_PLUGIN_FACTORY_DEFINITION( MobileQmlViewStepFactory, registerPlugin< MobileQmlViewStep >(); )

void
MobileQmlViewStep::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_config->setConfigurationMap( configurationMap );
    Calamares::QmlViewStep::setConfigurationMap( configurationMap );
}

MobileQmlViewStep::MobileQmlViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
    , m_config( new Config( this ) )
{
}

void
MobileQmlViewStep::onLeave()
{
    return;
}

bool
MobileQmlViewStep::isNextEnabled() const
{
    return false;
}

bool
MobileQmlViewStep::isBackEnabled() const
{
    return false;
}


bool
MobileQmlViewStep::isAtBeginning() const
{
    return true;
}


bool
MobileQmlViewStep::isAtEnd() const
{
    return true;
}


Calamares::JobList
MobileQmlViewStep::jobs() const
{
    return m_config->createJobs();
}

QObject*
MobileQmlViewStep::getConfig()
{
    return m_config;
}
